package com.example.oopnp.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "projects")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Project {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Назва проєкту не може бути пустою")
    @Size(min = 3, max = 100, message = "Назва проєкту має містити 3-100 символів")
    @Column(nullable = false)
    private String title;

    @NotBlank(message = "Опис проєкту не може бути пустим")
    @Size(min = 50, max = 500, message = "Опис проєкту має містити 50-500 символів")
    @Column(nullable = false)
    private String description;

    @Enumerated(EnumType.STRING)
    private ProjectStatus status = ProjectStatus.PROPOSAL;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    // Зв'язок із замовником
    @ManyToOne
    @JoinColumn(name = "customer_id", nullable = false)
    @ToString.Exclude
    private Customer customer;

    // Зв'язок із менеджером
    @ManyToOne
    @JoinColumn(name = "manager_id")
    @ToString.Exclude
    private Manager manager;

    // Список призначень розробників
    @ToString.Exclude
    @ManyToMany(mappedBy = "allProjects")
    private List<Developer> developers = new ArrayList<>();

    // Список завдань
    @ToString.Exclude
    @OneToMany(mappedBy = "project", cascade = CascadeType.ALL)
    private List<ProjectAssignment> assignments;

    @ToString.Exclude
    @OneToMany(mappedBy = "project", cascade = CascadeType.ALL)
    private List<Invoice> invoices = new ArrayList<>();

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "Невідомо";
        return createdAt.format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm"));
    }

    public String getFormattedCompletedAt() {
        if (completedAt == null) return "Невідомо";
        return completedAt.format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm"));
    }

}

