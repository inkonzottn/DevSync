package com.example.oopnp.entity;

import jakarta.persistence.*;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "developers")
@Data
@NoArgsConstructor
public class Developer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ToString.Exclude
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @Valid
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Qualification qualification;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Specialization specialization;


    @Min(value = 1, message = "Ставка не може бути меншою за 1")
    @Max(value = 5000, message = "Ставка не може перевищувати 5000")
    @Column(name = "hourly_rate", nullable = false)    private Double hourlyRate;

    @Column(name = "image_url")
    private String imageUrl;

    // Пряме посилання на проєкт, над яким розробник працює зараз
    @ToString.Exclude
    @ManyToOne
    @JoinColumn(name = "project_id")
    private Project currentProject;

    @ToString.Exclude
    @ManyToMany
    @JoinTable(
            name = "developer_projects",
            joinColumns = @JoinColumn(name = "developer_id"),
            inverseJoinColumns = @JoinColumn(name = "project_id")
    )
    private List<Project> allProjects = new ArrayList<>();


    // Допоміжний метод для перевірки зайнятості
    public boolean isBusy() {
        return currentProject != null;
    }

    @ToString.Exclude
    @ManyToMany
    @JoinTable(
            name = "developer_skills",
            joinColumns = @JoinColumn(name = "developer_id"),
            inverseJoinColumns = @JoinColumn(name = "skill_id")
    )
    private Set<Skill> skills;
}