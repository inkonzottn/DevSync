package com.example.oopnp.service;

import com.example.oopnp.entity.Developer;
import com.example.oopnp.entity.Role;
import com.example.oopnp.entity.User;
import com.example.oopnp.repository.DeveloperRepository;
import com.example.oopnp.repository.RoleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DeveloperService {
    private final DeveloperRepository developerRepository;
    private final UserService userService;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;


    // save
    @Transactional
    @CacheEvict(value = "developers", allEntries = true)
    public Developer saveNewDeveloper(Developer developer) {

        if (developer.getHourlyRate() < 0) throw new IllegalArgumentException("Ставка < 0");

        Role developerRole = roleRepository.findByName("ROLE_developer");
        User savedUser = userService.createUser(developer.getUser(), developerRole.getName());
        developer.setUser(savedUser);

        return developerRepository.save(developer);
    }

    // update
    @Transactional
    @CacheEvict(value = "developers", allEntries = true)
    public void updateDeveloper(Long id, Developer updatedDeveloper) {

        Developer existingDeveloper = developerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Розробника не знайдено"));

        existingDeveloper.setHourlyRate(updatedDeveloper.getHourlyRate());
        existingDeveloper.setQualification(updatedDeveloper.getQualification());
        existingDeveloper.setSpecialization(updatedDeveloper.getSpecialization());

        User user = existingDeveloper.getUser();
        user.setFirstName(updatedDeveloper.getUser().getFirstName());
        user.setLastName(updatedDeveloper.getUser().getLastName());

        user.setEmail(userService.prepareEmail(updatedDeveloper.getUser().getEmail(), user.getRoles().iterator().next()));

        // пароль міняємо ТІЛЬКИ якщо ввели новий
        if (updatedDeveloper.getUser().getPassword() != null && !updatedDeveloper.getUser().getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(updatedDeveloper.getUser().getPassword()));
        }

        developerRepository.save(existingDeveloper);
    }

    //delete
    @Transactional
    @CacheEvict(value = "developers", allEntries = true)
    public void deleteDeveloperById(Long id) {
        Developer developer = developerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Розробника з ID " + id + " не знайдено"));

        developerRepository.delete(developer);
    }

    // find
    @Cacheable(value = "developers", key = "'all'")
    public List<Developer> findAllDevelopers() {
        return developerRepository.findAll();
    }

    @Cacheable(value = "developers", key = "'all_free'")
    public List<Developer> findFreeDevelopers () {
        return developerRepository.findByCurrentProjectIsNull();
    }

    @Cacheable(value = "developers", key = "'dev_' + #id")
    public Developer findDeveloperById(Long id) {
        return developerRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Розробника не знайдено"));
    }

    @Cacheable(value = "developers", key = "'dev_user_' + #id")
    public Developer findByUserId(Long id) {
        return developerRepository.findByUserId(id)
                .orElseThrow(() -> new IllegalArgumentException("Користувача не знайдено"));
    }

}
