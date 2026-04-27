package com.example.oopnp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.security.Principal;

@Controller
public class TestController {

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping({"/admin/welcome", "/manager/welcome", "/developer/welcome", "/customer/welcome"})
    public String getPageWelcome() {
        return "welcome";
    }

}
