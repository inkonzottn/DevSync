package com.example.oopnp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

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
