package com.example.oopnp.controller.customer;

import com.example.oopnp.entity.User;
import com.example.oopnp.service.ProjectAssignmentService;
import com.example.oopnp.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@Controller
@RequiredArgsConstructor
@RequestMapping("/customer")
public class CustomerController {

    // TODO Profile

    private final UserService userService;
    private final ProjectAssignmentService projectAssignmentService;

    @GetMapping("project-assignments")
    public String getCustomerProjectAssignments(Principal principal, Model model) {
        User currentUser = userService.findUserByEmail(principal.getName());
        model.addAttribute("projectAssignments", projectAssignmentService.findProjectAssignmentsForCustomer(currentUser.getId()));
        return "project-assignments";
    }

}
