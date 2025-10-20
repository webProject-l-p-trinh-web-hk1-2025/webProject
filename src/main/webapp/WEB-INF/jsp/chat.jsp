<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="/css/main.css" />
    <title>Chat Application</title>
  </head>
  <body>
    <h2>One to One Chat | Spring boot & Websocket | By Alibou</h2>

    <div class="user-form" id="username-page">
      <h2>Enter Chatroom</h2>
      <div id="autoUserInfo">
        <!-- This area will be replaced with server user info if authenticated -->
        <p>Checking authentication...</p>
      </div>
      <form id="usernameForm" style="display: none">
        <label for="nickname">Nickname:</label>
        <input type="text" id="nickname" name="nickname" required />

        <label for="fullname">Real Name:</label>
        <input type="text" id="fullname" name="realname" required />

        <label for="recipient">Recipient (user id or nickname):</label>
        <input
          type="text"
          id="recipient"
          name="recipient"
          placeholder="recipient id"
          required
        />

        <button type="submit">Enter Chatroom</button>
      </form>
    </div>

    <div class="chat-container hidden" id="chat-page">
      <div class="users-list">
        <div class="users-list-container">
          <h2>Online Users</h2>
          <ul id="connectedUsers"></ul>
        </div>
        <div>
          <p id="connected-user-fullname"></p>
          <a class="logout" href="javascript:void(0)" id="logout">Logout</a>
        </div>
      </div>

      <div class="chat-area">
        <div class="chat-area" id="chat-messages"></div>
        <div style="margin: 8px 0">
          <label for="recipientDisplay">To:</label>
          <span id="recipientDisplay"></span>
        </div>

        <form id="messageForm" name="messageForm" class="hidden">
          <div class="message-input">
            <input
              autocomplete="off"
              type="text"
              id="message"
              placeholder="Type your message..."
            />
            <input type="file" id="fileInput" accept="image/*,video/*" />
            <button>Send</button>
          </div>
        </form>
      </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script src="/js/main.js"></script>
    <!-- Media modal -->
    <div id="mediaModal" class="hidden media-modal" onclick="closeMediaModal()">
      <div
        class="media-modal-inner"
        id="mediaModalContent"
        onclick="event.stopPropagation()"
      ></div>
    </div>
  </body>
</html>
