package com.example.webProject.user.entity;

import java.util.Collection;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.example.webProject.common.entity.BaseEntity;
// import com.example.webProject.document.entity.Document;
// import com.example.webProject.event.entity.Event;
// import com.example.webProject.project.entity.Project;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User extends BaseEntity implements UserDetails {

    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    @Column(nullable = false, unique = true, length = 255)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    @JsonIgnore
    private String passwordHash;

    @Column(name = "avatar_url", length = 255)
    private String avatarUrl;

    @Column(nullable = false)
    private UserRole role;

    /* future feature
    TODO: Viết có thêm department khi clb có nhiều thành viên hơn
    @ManyToOne
    @JoinColumn(name = "department_id", foreignKey = @ForeignKey(name = "fk_user_department"))
    private Department department;
     */
    @Builder.Default
    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;
    @Column(length = 1000)
    private String refreshToken;

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return isActive;
    }

    public boolean isActive() {
        return isActive;
    }

    // Bạn cần override thêm các phương thức UserDetails:
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(() -> role.name());
    }

    @Override
    @JsonIgnore
    public String getPassword() {

        return this.passwordHash;
    }

    // Linking stuff here
    //1 User have many Event
    // @OneToMany(mappedBy = "creator")
    // private List<Event> authoredEvents;
    // //1 User have many Project
    // @OneToMany(mappedBy = "creator")
    // private List<Project> authoredProjects;
    // //1 User have many Document
    // @OneToMany(mappedBy = "creator")
    // private List<Document> authoredDocuments;
    //1 User have many Blog
}
