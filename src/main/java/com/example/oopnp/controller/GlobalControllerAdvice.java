package com.example.oopnp.controller;

import com.example.oopnp.entity.User;
import com.example.oopnp.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.security.Principal;

@ControllerAdvice
@RequiredArgsConstructor
public class GlobalControllerAdvice {

    private  UserService userService;

    @ModelAttribute
    public void addAttributes(Model model, Principal principal, Authentication auth) {
        if (principal != null && auth != null) {
            String email = principal.getName();

            User user = userService.findUserByEmail(email);

            if (user != null) {
                model.addAttribute("username", user.getFirstName());
                model.addAttribute("currentUserId", user.getId());
            } else {
                model.addAttribute("username", email);
            }

            model.addAttribute("isAuth", true);

            boolean isAdmin = auth.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_admin"));
            boolean isManager = auth.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_manager"));
            boolean isDeveloper = auth.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_developer"));
            boolean isCustomer = auth.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_customer"));


            String rolePath = "customer";
            if (isAdmin) rolePath = "admin";
            else if (isManager) rolePath = "manager";
            else if (isDeveloper) rolePath = "developer";

            model.addAttribute("rolePath", rolePath);

            model.addAttribute("isAdmin", isAdmin);
            model.addAttribute("isManager", isManager);
            model.addAttribute("isDeveloper", isDeveloper);
            model.addAttribute("isCustomer", isCustomer);
        } else {
            model.addAttribute("isAuth", false);
        }
    }
}
