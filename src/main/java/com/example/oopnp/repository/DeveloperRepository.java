package com.example.oopnp.repository;

import com.example.oopnp.entity.Developer;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface DeveloperRepository extends JpaRepository<Developer, Long> {
    Developer findByUserFirstName(String firstName);

    Optional<Developer> findByUserId(Long userId);

    List<Developer> findByCurrentProjectIsNull();

    // знаходимо всіх девів, у яких цей проєкт встановлений як поточний
    List<Developer> findByCurrentProjectId(Long projectId);
}
