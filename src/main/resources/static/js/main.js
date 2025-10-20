"use strict";
"use strict";

const usernamePage = document.querySelector("#username-page");
const chatPage = document.querySelector("#chat-page");
const usernameForm = document.querySelector("#usernameForm");
const messageForm = document.querySelector("#messageForm");
const messageInput = document.querySelector("#message");
const fileInput = document.querySelector("#fileInput");
const connectingElement = document.querySelector(".connecting");
const chatArea = document.querySelector("#chat-messages");
const logout = document.querySelector("#logout");

let stompClient = null;
let nickname = null;
let fullname = null;
let selectedUserId = null;
let currentRole = "USER";

// ------------------------- Auth & connect -------------------------
async function initAuth() {
  try {
    const resp = await fetch("/api/me");
    if (!resp.ok) return showManualLogin();
    const info = await resp.json();
    if (info && info.authenticated) {
      nickname = info.phone || info.email || "user" + info.id;
      fullname = info.fullName || nickname;
      currentRole = (info.role || "USER").toUpperCase();

      if (usernamePage) usernamePage.classList.add("hidden");
      if (chatPage) chatPage.classList.remove("hidden");
      const connectedFullname = document.querySelector(
        "#connected-user-fullname"
      );
      if (connectedFullname) connectedFullname.textContent = fullname;

      const socket = new SockJS("/ws");
      stompClient = Stomp.over(socket);
      stompClient.connect({}, onConnected, onError);
      return;
    }
  } catch (err) {
    console.debug("initAuth: /api/me failed", err);
  }
  showManualLogin();
}

function showManualLogin() {
  if (usernameForm) usernameForm.style.display = "";
}

function connect(event) {
  nickname = document.querySelector("#nickname").value.trim();
  fullname = document.querySelector("#fullname").value.trim();

  if (nickname && fullname) {
    usernamePage.classList.add("hidden");
    chatPage.classList.remove("hidden");

    const socket = new SockJS("/ws");
    stompClient = Stomp.over(socket);

    stompClient.connect({}, onConnected, onError);
  }
  event.preventDefault();
}

function onConnected() {
  stompClient.subscribe(`/user/${nickname}/queue/messages`, onMessageReceived);
  stompClient.subscribe(`/user/public`, onMessageReceived);
  stompClient.send(
    "/app/user.addUser",
    {},
    JSON.stringify({
      nickName: nickname,
      fullName: fullname,
      status: "ONLINE",
      role: currentRole,
    })
  );

  document.querySelector("#connected-user-fullname").textContent = fullname;
  findAndDisplayConnectedUsers().then(() => {
    if (currentRole === "ADMIN") {
      // load conversation list (users who've messaged this admin) so admin can reply even if they're offline
      loadAdminConversations().catch((e) =>
        console.debug("loadAdminConversations failed", e)
      );
    }
    if (currentRole !== "ADMIN") {
      const adminElem = Array.from(
        document.querySelectorAll(".user-item")
      ).find((el) => (el.dataset.role || "").toUpperCase() === "ADMIN");
      if (adminElem) adminElem.click();
    }
  });
}

function onError() {
  if (connectingElement) {
    connectingElement.textContent =
      "Could not connect to WebSocket server. Please refresh this page to try again!";
    connectingElement.style.color = "red";
  }
}

// ------------------------- Users list -------------------------
async function findAndDisplayConnectedUsers() {
  const connectedUsersResponse = await fetch("/users");
  let connectedUsers = await connectedUsersResponse.json();

  connectedUsers = connectedUsers.filter((user) => user.nickName !== nickname);

  // If current user is a normal USER, only show admins — but also include admins that are offline
  if (currentRole !== "ADMIN") {
    connectedUsers = connectedUsers.filter(
      (user) => (user.role || "").toUpperCase() === "ADMIN"
    );

    // fetch admins list (may include offline admins) and merge
    try {
      const adminsResp = await fetch("/users/admins");
      if (adminsResp.ok) {
        const admins = await adminsResp.json();
        admins.forEach((a) => {
          // create object shape compatible with registry responses
          const adminObj = {
            nickName: a.phone || a.email,
            fullName: a.fullName,
            role: "ADMIN",
          };
          // if admin not already in connectedUsers list, add as offline entry
          if (!connectedUsers.find((u) => u.nickName === adminObj.nickName)) {
            adminObj.status = "OFFLINE";
            connectedUsers.push(adminObj);
          }
        });
      }
    } catch (e) {
      console.debug("Could not fetch /users/admins", e);
    }
  }

  const connectedUsersList = document.getElementById("connectedUsers");
  connectedUsersList.innerHTML = "";

  connectedUsers.forEach((user, idx) => {
    appendUserElement(user, connectedUsersList);
    if (idx < connectedUsers.length - 1) {
      const separator = document.createElement("li");
      separator.classList.add("separator");
      connectedUsersList.appendChild(separator);
    }
  });
}

function appendUserElement(user, connectedUsersList) {
  const listItem = document.createElement("li");
  listItem.classList.add("user-item");
  listItem.id = user.nickName; // stable id for mapping messages

  listItem.dataset.role = (user.role || "USER").toUpperCase();

  const userImage = document.createElement("img");
  userImage.src = "../img/user_icon.png";
  userImage.alt = user.fullName;

  const usernameSpan = document.createElement("span");
  usernameSpan.textContent = user.fullName;

  const receivedMsgs = document.createElement("span");
  receivedMsgs.textContent = "0";
  receivedMsgs.classList.add("nbr-msg", "hidden");

  listItem.appendChild(userImage);
  listItem.appendChild(usernameSpan);
  listItem.appendChild(receivedMsgs);

  listItem.addEventListener("click", userItemClick);

  connectedUsersList.appendChild(listItem);
}

function userItemClick(event) {
  document.querySelectorAll(".user-item").forEach((item) => {
    item.classList.remove("active");
  });
  messageForm.classList.remove("hidden");

  const clickedUser = event.currentTarget;
  clickedUser.classList.add("active");

  selectedUserId = clickedUser.getAttribute("id");

  fetchAndDisplayUserChat().then();

  const nbrMsg = clickedUser.querySelector(".nbr-msg");
  if (nbrMsg) {
    nbrMsg.classList.add("hidden");
    nbrMsg.textContent = "0";
  }
}

async function loadAdminConversations() {
  if (!nickname) return;
  try {
    const resp = await fetch(`/conversations/${nickname}`);
    if (!resp.ok) return;
    const senders = await resp.json(); // array of senderIds (nick)
    for (const sender of senders) {
      // ensure each sender appears in the user list (fetch user details if necessary)
      await ensureUserItem(sender);
    }
  } catch (e) {
    console.debug("loadAdminConversations error", e);
  }
}

async function ensureUserItem(nick) {
  if (!nick) return;
  // if already present, nothing to do
  if (document.getElementById(nick)) return;

  // try to fetch user details
  try {
    const resp = await fetch(`/users/${encodeURIComponent(nick)}`);
    if (!resp.ok) {
      // fallback: show nick only
      appendUserElement(
        { nickName: nick, fullName: nick, role: "USER", status: "OFFLINE" },
        document.getElementById("connectedUsers")
      );
      return;
    }
    const u = await resp.json();
    const obj = {
      nickName: u.phone || u.email,
      fullName: u.fullName || u.phone || u.email,
      role: u.role || "USER",
    };
    obj.status = "OFFLINE";
    appendUserElement(obj, document.getElementById("connectedUsers"));
  } catch (e) {
    console.debug("ensureUserItem failed", e);
    appendUserElement(
      { nickName: nick, fullName: nick, role: "USER", status: "OFFLINE" },
      document.getElementById("connectedUsers")
    );
  }
}

// ------------------------- Message rendering -------------------------
function displayMessage(senderId, content, timestamp) {
  const messageContainer = document.createElement("div");
  messageContainer.classList.add("message");
  if (senderId === nickname) {
    messageContainer.classList.add("sender");
  } else {
    messageContainer.classList.add("receiver");
  }
  const message = document.createElement("p");
  message.textContent = content;
  messageContainer.appendChild(message);
  // timestamp placeholder (history or real-time will fill)
  const ts = document.createElement("div");
  ts.classList.add("msg-ts");
  ts.style.fontSize = "0.8rem";
  ts.style.color = "#666";
  ts.style.marginTop = "4px";
  ts.textContent = "";
  messageContainer.appendChild(ts);
  chatArea.appendChild(messageContainer);
  if (timestamp) ts.textContent = formatTimestamp(timestamp);
  return messageContainer;
}

function displayMediaMessage(senderId, mediaPath, mediaType) {
  const container = document.createElement("div");
  container.classList.add("message");
  if (senderId === nickname) container.classList.add("sender");
  else container.classList.add("receiver");

  if ((mediaType || "").startsWith("image/")) {
    const img = document.createElement("img");
    img.src = `/media/${encodeURIComponent(mediaPath)}`;
    img.alt = "image";
    img.style.maxWidth = "320px";
    img.style.cursor = "pointer";
    img.addEventListener("click", () => openMediaModal(mediaPath, mediaType));
    container.appendChild(img);
  } else if ((mediaType || "").startsWith("video/")) {
    const video = document.createElement("video");
    video.src = `/media/${encodeURIComponent(mediaPath)}`;
    video.controls = true;
    video.style.maxWidth = "480px";
    video.style.cursor = "pointer";
    video.addEventListener("click", () => openMediaModal(mediaPath, mediaType));
    container.appendChild(video);
  } else {
    const link = document.createElement("a");
    link.href = `/media/${encodeURIComponent(mediaPath)}`;
    link.textContent = "Download file";
    container.appendChild(link);
  }

  const ts = document.createElement("div");
  ts.classList.add("msg-ts");
  ts.style.fontSize = "0.8rem";
  ts.style.color = "#666";
  ts.style.marginTop = "4px";
  ts.textContent = "";
  container.appendChild(ts);

  chatArea.appendChild(container);
  return container;
}

function formatTimestamp(dateStrOrMillis) {
  if (!dateStrOrMillis) return "";
  const d =
    typeof dateStrOrMillis === "number"
      ? new Date(dateStrOrMillis)
      : new Date(dateStrOrMillis);
  // show time now for recent messages, otherwise date and time
  const now = new Date();
  const sameDay = d.toDateString() === now.toDateString();
  if (sameDay) {
    return d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
  }
  return d.toLocaleString([], {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function openMediaModal(mediaPath, mediaType) {
  let modal = document.getElementById("mediaModal");
  let modalContent = document.getElementById("mediaModalContent");
  if (!modal || !modalContent) return;
  modalContent.innerHTML = "";
  if ((mediaType || "").startsWith("image/")) {
    const img = document.createElement("img");
    img.src = `/media/${encodeURIComponent(mediaPath)}`;
    img.style.maxWidth = "90vw";
    img.style.maxHeight = "90vh";
    modalContent.appendChild(img);
  } else if ((mediaType || "").startsWith("video/")) {
    const video = document.createElement("video");
    video.src = `/media/${encodeURIComponent(mediaPath)}`;
    video.controls = true;
    video.autoplay = true;
    video.style.maxWidth = "90vw";
    video.style.maxHeight = "90vh";
    modalContent.appendChild(video);
  } else {
    const link = document.createElement("a");
    link.href = `/media/${encodeURIComponent(mediaPath)}`;
    link.textContent = "Download file";
    modalContent.appendChild(link);
  }
  modal.classList.remove("hidden");
}

function closeMediaModal() {
  const modal = document.getElementById("mediaModal");
  const modalContent = document.getElementById("mediaModalContent");
  if (!modal) return;
  modal.classList.add("hidden");
  if (modalContent) modalContent.innerHTML = "";
}

async function fetchAndDisplayUserChat() {
  const userChatResponse = await fetch(
    `/messages/${nickname}/${selectedUserId}`
  );
  const userChat = await userChatResponse.json();
  chatArea.innerHTML = "";
  userChat.forEach((chat) => {
    if (chat.mediaPath) {
      const el = displayMediaMessage(
        chat.senderId,
        chat.mediaPath,
        chat.mediaType
      );
      if (el) {
        const ts = el.querySelector(".msg-ts");
        if (ts) ts.textContent = formatTimestamp(chat.timestamp);
      }
    } else {
      const el = displayMessage(chat.senderId, chat.content, chat.timestamp);
      if (el) {
        // already set inside displayMessage
      }
    }
  });
  chatArea.scrollTop = chatArea.scrollHeight;
}

// ------------------------- Send message / upload -------------------------
async function sendMessage(event) {
  event.preventDefault();

  if (!stompClient || !selectedUserId) return;

  const messageContent = messageInput.value.trim();

  // If user selected a file, upload first
  const file = fileInput ? fileInput.files[0] : null;
  if (file) {
    const form = new FormData();
    form.append("file", file);
    try {
      const resp = await fetch("/api/media/upload", {
        method: "POST",
        body: form,
      });
      if (resp.ok) {
        const media = await resp.json();
        const chatMessage = {
          senderId: nickname,
          recipientId: selectedUserId,
          content: messageContent || "",
          mediaPath: media.path,
          mediaType: media.contentType,
          timestamp: new Date().toISOString(),
        };
        stompClient.send("/app/chat", {}, JSON.stringify(chatMessage));

        if (chatMessage.mediaPath)
          displayMediaMessage(
            nickname,
            chatMessage.mediaPath,
            chatMessage.mediaType
          );
        messageInput.value = "";
        if (fileInput) fileInput.value = null;
      } else {
        console.warn("media upload failed");
      }
    } catch (err) {
      console.error("upload error", err);
    }
    chatArea.scrollTop = chatArea.scrollHeight;
    return;
  }

  // Otherwise send text
  if (messageContent) {
    const chatMessage = {
      senderId: nickname,
      recipientId: selectedUserId,
      content: messageContent,
      timestamp: new Date().toISOString(),
    };
    stompClient.send("/app/chat", {}, JSON.stringify(chatMessage));
    const el = displayMessage(nickname, messageContent);
    if (el) {
      const tsEl = el.querySelector(".msg-ts");
      if (tsEl) tsEl.textContent = formatTimestamp(new Date());
    }
    messageInput.value = "";
    chatArea.scrollTop = chatArea.scrollHeight;
  }
}

// ------------------------- On message receive -------------------------
async function onMessageReceived(payload) {
  console.debug("Message received", payload);

  const message = JSON.parse(payload.body);
  const senderId = message.senderId;
  const senderElem = document.getElementById(senderId);

  // If chat with sender is open, append the incoming message (text or media)
  if (selectedUserId && selectedUserId === senderId) {
    if (message.mediaPath) {
      const el = displayMediaMessage(
        senderId,
        message.mediaPath,
        message.mediaType
      );
      if (el) {
        const ts = el.querySelector(".msg-ts");
        if (ts) ts.textContent = formatTimestamp(message.timestamp);
      }
    } else if (message.content) {
      const el = displayMessage(senderId, message.content, message.timestamp);
      if (el) {
        // timestamp set inside displayMessage
      }
    }

    chatArea.scrollTop = chatArea.scrollHeight;

    if (senderElem) {
      const nbr = senderElem.querySelector(".nbr-msg");
      if (nbr) {
        nbr.classList.add("hidden");
        nbr.textContent = "0";
      }
    }

    return;
  }

  // If chat with sender is not open, increment unread badge
  if (senderElem) {
    const nbrMsg = senderElem.querySelector(".nbr-msg");
    if (nbrMsg) {
      let count = parseInt(nbrMsg.textContent) || 0;
      nbrMsg.textContent = count + 1;
      nbrMsg.classList.remove("hidden");
    }
  }
}

function onLogout() {
  stompClient.send(
    "/app/user.disconnectUser",
    {},
    JSON.stringify({
      nickName: nickname,
      fullName: fullname,
      status: "OFFLINE",
    })
  );
  window.location.reload();
}

usernameForm.addEventListener("submit", connect, true);
messageForm.addEventListener("submit", sendMessage, true);
logout.addEventListener("click", onLogout, true);
window.onbeforeunload = () => onLogout();

initAuth();
