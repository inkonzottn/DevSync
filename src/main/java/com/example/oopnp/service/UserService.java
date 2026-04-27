package com.example.oopnp.service;

import com.example.oopnp.entity.*;
import com.example.oopnp.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.Objects;


@Service
@RequiredArgsConstructor
public class UserService implements UserDetailsService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final DeveloperRepository developerRepository;
    private final ManagerRepository managerRepository;
    private final CustomerRepository customerRepository;
    private final PasswordEncoder passwordEncoder;


    @Override
    @Cacheable(value = "users", key = "#email")
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {

        User user = userRepository.findByEmail(email);

        if (user == null) {
            throw new UsernameNotFoundException("User with email: " + email + " is not foud.");
        }

        return user;
    }


    @Cacheable(value = "users", key = "#email")
    public User findUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }


    // створення системних користувачів (адмін/дев/менеджер), тільки з адмінки
    @Transactional
    @CacheEvict(value = "users", allEntries = true)
    public User createUser(User user, String roleName) {
        Role role = roleRepository.findByName(roleName);
        user.setEmail(prepareEmail(user.getEmail(), role));
        return saveWithRole(user, role);
    }


    // реєстрація клієнта
    @Transactional
    @Caching(evict = {
            @CacheEvict(value = "users", allEntries = true),
            @CacheEvict(value = "customers", allEntries = true)
    })
    public User registerCustomer(Customer customer) {

        User user = customer.getUser();
        validateCustomerEmail(user.getEmail());

        Role customerRole = roleRepository.findByName("ROLE_customer");
        User savedUser = saveWithRole(user, customerRole);

        customer.setUser(savedUser);
        customerRepository.save(customer);
        return savedUser;
    }


    // створення корпоративного імейлу devsync.dev.com/.mng.com в залежності від ролі
    public String prepareEmail(String email, Role role) {
        String domain = role.getDomain();

        if (domain == null || domain.isEmpty()) {
            return email;
        }

        String name = email.contains("@") ? email.split("@")[0] : email;
        return name.toLowerCase() + "@" + domain;
    }

    // перевірка, чи не намагається клієнт використати наш корпоративний домен
    private void validateCustomerEmail(String email) {

        if (email == null || !email.contains("@")) {
            throw new IllegalArgumentException("Invalid email format");
        }
        String userDomain = email.substring(email.lastIndexOf("@") + 1).toLowerCase();

        // якщо в домені є "devsync" — не реєструємо
        if (userDomain.contains("devsync")) {
            throw new IllegalArgumentException("This domain is reserved!");
        }

        List<String> forbiddenDomains = roleRepository.findAll().stream()
                .map(Role::getDomain)
                .filter(Objects::nonNull)
                .toList();

        boolean isForbidden = forbiddenDomains.stream().anyMatch(domain ->
                userDomain.equals(domain) || userDomain.endsWith("." + domain)
        );

        if (isForbidden) {
            throw new IllegalArgumentException("This domain is reserved!");
        }
    }

    // спільна логіка збереження користувачів
    private User saveWithRole(User user, Role role) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRoles(Collections.singleton(role));
        user.setEnabled(true);
        return userRepository.save(user);
    }
}
