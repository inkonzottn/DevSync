package com.example.oopnp.controller.admin;

import com.example.oopnp.entity.Developer;
import com.example.oopnp.entity.Qualification;
import com.example.oopnp.entity.Specialization;
import com.example.oopnp.service.DeveloperService;
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
@RequestMapping("/admin/developers")
public class AdminDeveloperController {

    private final DeveloperService developerService;

    @ModelAttribute("qualifications")
    public Qualification[] populateQualifications() {
        return Qualification.values();
    }

    @ModelAttribute("specializations")
    public Specialization[] populateSpecializations() {
        return Specialization.values();
    }

    @GetMapping
    public String getAdminDevelopers(Model model) {
        model.addAttribute("developers", developerService.findAllDevelopers());
        return "developers";
    }

    // create
    @GetMapping("/create")
    public String getDeveloperCreateForm(Model model) {
        return "developer-create";
    }

    @PostMapping("/create")
    public String createDeveloper(@Valid @ModelAttribute("developer") Developer developer,
                                  BindingResult bindingResult,
                                  Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("errors", extractValidationErrors(bindingResult));
            model.addAttribute("developer", developer);
            return "developer-create";
        }

        try {
            developerService.saveNewDeveloper(developer);
            return "redirect:/admin/developers";
        } catch (IllegalArgumentException e) {
            model.addAttribute("message", e.getMessage());
            return "developer-create";
        }
    }


    // edit
    @GetMapping("/edit/{id}")
    public String getDeveloperEditForm(@PathVariable Long id, Model model) {

        Developer developer = developerService.findDeveloperById(id);
        model.addAttribute("developer", developer);
        return "developer-edit";
    }

    @PostMapping("/edit/{id}")
    public String updateDeveloper(@PathVariable Long id,
                                  @Valid @ModelAttribute("developer") Developer developer,
                                  BindingResult bindingResult,
                                  Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("errors", extractValidationErrors(bindingResult));
            model.addAttribute("developer", developer);
            return "developer-create";
        }

        try {
            developerService.updateDeveloper(id, developer);
            return "redirect:/admin/developers";
        } catch (IllegalArgumentException e) {
            model.addAttribute("message", e.getMessage());
            return "developer-edit";
        }
    }


    // delete
    @PostMapping("/delete/{id}")
    public String deleteDeveloper(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            developerService.deleteDeveloperById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Розробника успішно видалено");
        } catch (Exception e) {
            // якщо видалити не можна (є прив'язка)
            redirectAttributes.addFlashAttribute("errorMessage", "Не можна видалити розробника: він прив'язаний до проєкту.");
        }
        return "redirect:/admin/developers";
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
