package com.example.oopnp.controller.admin;

import com.example.oopnp.entity.Manager;
import com.example.oopnp.service.ManagerService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/managers")
public class AdminManagerController {

    private final ManagerService managerService;

    @GetMapping
    public String getAdminManagers(Model model) {
        model.addAttribute("managers", managerService.getAllManagersWithActiveProjects());
        return "managers";
    }

    // create
    @GetMapping("/create")
    public String getManagerCreateForm(Model model) {
        return "manager-create";
    }

    @PostMapping("/create")
    public String createManager(@Valid @ModelAttribute("manager") Manager manager,
                                BindingResult bindingResult,
                                Model model) {


        if (bindingResult.hasErrors()) {
            model.addAttribute("errors", extractValidationErrors(bindingResult));
            model.addAttribute("manager", manager);
            return "manager-create";
        }

        try {
            managerService.saveNewManager(manager);
            return "redirect:/admin/managers";
        } catch (IllegalArgumentException e) {
            model.addAttribute("message", e.getMessage());
            return "manager-create";
        }
    }


    // edit
    @GetMapping("/edit/{id}")
    public String getManagerEditForm(@PathVariable Long id, Model model) {
        Manager manager = managerService.findManagerById(id);
        model.addAttribute("manager", manager);
        return "manager-edit";
    }

    @PostMapping("/edit/{id}")
    public String updateManager(@PathVariable Long id,
                                @Valid @ModelAttribute("manager") Manager manager,
                                BindingResult bindingResult,
                                Model model) {


        if (bindingResult.hasErrors()) {
            model.addAttribute("errors", extractValidationErrors(bindingResult));
            model.addAttribute("manager", manager);
            return "manager-edit";
        }


        try {
            managerService.updateManager(id, manager);
            return "redirect:/admin/managers";
        } catch (IllegalArgumentException e) {
            model.addAttribute("message", e.getMessage());
            return "manager-edit";
        }
    }


    // delete
    @PostMapping("/delete/{id}")
    public String deleteManager(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            managerService.deleteManagerById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Менеджера успішно видалено");
        } catch (Exception e) {
            // якщо видалити не можна (є прив'язка)
            redirectAttributes.addFlashAttribute("errorMessage", "Не можна видалити менеджера: він прив'язаний до проєкту.");
        }
        return "redirect:/admin/managers";
    }


    private Map<String, String> extractValidationErrors(BindingResult bindingResult) {
        return bindingResult.getFieldErrors().stream()
                .collect(Collectors.toMap(
                        FieldError::getField,
                        FieldError::getDefaultMessage,
                        (existing, replacement) -> existing
                ));
    }
}
