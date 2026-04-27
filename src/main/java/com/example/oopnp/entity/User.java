package com.example.oopnp.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Set;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Email не може бути пустим")
    @Size(min = 2, max = 50, message = "Логін має містити 2-50 символів")
    @Pattern(
            regexp = "^[a-zA-Z0-9._]+(@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})?$",
            message = "Email неправильного формату"
    )
    @Column(unique = true, nullable = false)
    private String email; // логін

    @NotBlank(message = "Ім'я не може бути пустим")
    @Size(min = 2, max = 50, message = "Ім'я має містити 2-50 символів")
    @Pattern(regexp = "^[A-Za-zА-Яа-яІіЇїЄєҐґ'\\s-]+$", message = "Ім'я може містити тільки літери")
    @Column(nullable = false)
    private String firstName;

    @NotBlank(message = "Прізвище не може бути пустим")
    @Size(min = 2, max = 50, message = "Прізвище має містити 2-50 символів")
    @Pattern(regexp = "^[A-Za-zА-Яа-яІіЇїЄєҐґ'\\s-]+$", message = "Прізвище може містити тільки літери")
    @Column(nullable = false)
    private String lastName;

    @NotBlank(message = "Пароль обов'язковий")
    @Size(min = 8, message = "Пароль має містити принаймні 8 символів")
    @Column(nullable = false)
    private String password;

    private boolean enabled = true;

    @ToString.Exclude
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "user_roles",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    private Set<Role> roles;


    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return roles;
    }

    @Override
    public boolean isAccountNonExpired() {
        return UserDetails.super.isAccountNonExpired();
    }

    @Override
    public boolean isAccountNonLocked() {
        return UserDetails.super.isAccountNonLocked();
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return UserDetails.super.isCredentialsNonExpired();
    }

    @Override
    public boolean isEnabled() { return enabled; }
}