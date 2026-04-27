package com.example.oopnp.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "invoices")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Invoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Double finalPrice;

    @Column(nullable = false)
    private Double devCosts;

    @CreationTimestamp
    @Column(nullable = false)
    private LocalDateTime createdAt;

    @Column(nullable = true)
    private LocalDateTime completedAt;

    @Enumerated(EnumType.STRING)
    private InvoiceStatus status = InvoiceStatus.PENDING;

    @ToString.Exclude
    @ManyToOne
    @JoinColumn(name = "project_id", nullable = false)
    private Project project;


    public String getFormattedCreatedAt() {
        if (createdAt == null) return "Невідомо";
        return createdAt.format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm"));
    }

    public String getFormattedCompletedAt() {
        if (completedAt == null) return "Невідомо";
        return completedAt.format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm"));
    }
}