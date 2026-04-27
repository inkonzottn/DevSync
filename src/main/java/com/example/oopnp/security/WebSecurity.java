package com.example.oopnp.security;

import com.example.oopnp.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class WebSecurity {

    private final UserService userService;

    @Bean
    public SecurityFilterChain configure(HttpSecurity http) throws Exception {

        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(authorizeRequests ->
                        authorizeRequests
                                // публічні сторінки
                                .requestMatchers("/", "/login", "/registration", "/static/**",
                                        "/css/**", "/js/**").permitAll()


                                // доступ за ролями
                                .requestMatchers("/manager/**").hasAuthority("ROLE_MANAGER")
                                .requestMatchers("/developer/**").hasAuthority("ROLE_developer")
                                .requestMatchers("/customer/**").hasAuthority("ROLE_customer")
                                .requestMatchers("/admin/**").hasAuthority("ROLE_admin")
                                .anyRequest()
                                .authenticated()
                )
                .formLogin(form ->
                        form
                                .loginPage("/login")
                                .usernameParameter("email")
                                .passwordParameter("password")
                                .defaultSuccessUrl("/")
                                .permitAll()
                )
                .logout(
                        logout -> logout
                                .permitAll().logoutSuccessUrl("/")
                );


        return http.build();
    }
}
