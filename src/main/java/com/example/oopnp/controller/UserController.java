package com.example.oopnp.controller;

import com.example.oopnp.entity.Customer;
import com.example.oopnp.entity.User;
import com.example.oopnp.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/registration")
    public String registration(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("errors", Collections.emptyMap());
        return "registration";
    }

    @PostMapping("/registration")
    public String addUser(@Valid @ModelAttribute("customer") Customer customer,
                          BindingResult bindingResult,
                          Model model) {

        if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = bindingResult.getFieldErrors().stream()
                    .collect(Collectors.toMap(
                            FieldError::getField,
                            FieldError::getDefaultMessage,
                            (existing, replacement) -> existing
                    ));

            model.addAttribute("errors", errorsMap);
            model.addAttribute("customer", customer);

            System.out.println(errorsMap);


            return "registration";
        }


        try {
            userService.registerCustomer(customer);
            return "redirect:/login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("message", e.getMessage());
            model.addAttribute("errors", Collections.emptyMap());
            model.addAttribute("customer", customer);
            return "registration";
        }
    }
}
