package com.example.oopnp.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "project_assignments")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProjectAssignment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Назва завдання не може бути пустою")
    @Size(min = 10, max = 100, message = "Назва завдання має містити 10-100 символів")
    @Column(nullable = false)
    private String title;

    @NotBlank(message = "Опис завдання не може бути пустим")
    @Size(min = 10, max = 150, message = "Опис завдання має містити 10-150 символів")
    @Column(columnDefinition = "TEXT")
    private String description;

    @ManyToOne
    @JoinColumn(name = "developer_id", nullable = false)
    @ToString.Exclude
    private Developer developer;

    @ManyToOne
    @JoinColumn(name = "project_id", nullable = false)
    @ToString.Exclude
    private Project project;

    @Min(value = 0, message = "Кількість годин не може бути меншою за 0")
    @Max(value = 500, message = "Кількість годин не може перевищувати 500")
    @Column(name = "spent_hours")
    private Integer spentHours = 0;

    @Min(value = 0, message = "Кількість хвилин не може бути меншою за 0")
    @Max(value = 59, message = "Кількість хвилин не може перевищувати 59")
    @Column(name = "spent_minutes")
    private Integer spentMinutes = 0;

    @Column(name = "is_active")
    private boolean isActive = true; // чи працює він над цим прямо зараз

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;


    public String getFormattedCreatedAt() {
        if (createdAt == null) return "Невідомо";
        return createdAt.format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm"));
    }

    public String getFormattedCompletedAt() {
        if (completedAt == null) return "Невідомо";
        return completedAt.format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm"));
    }
}
