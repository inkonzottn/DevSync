<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Менеджери | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        /* Фікс сайдбару назавжди */
        .sidebar { flex-shrink: 0 !important; }
        .main-content { min-width: 0; overflow-x: hidden; }
        .manager-card { transition: transform 0.2s ease; }
        .manager-card:hover { transform: translateY(-2px); }
    </style>
</head>
<body class="d-flex bg-light">

<#include "sidebar.ftl">

<div class="main-content flex-grow-1 p-4" style="min-width: 0;">
    <div class="container-fluid" style="max-width: 1200px;">

        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold m-0 text-dark">Менеджери</h2>
                <p class="text-muted small mb-0 mt-1">Команда управління та їхні поточні проєкти</p>
            </div>

            <#if isAdmin?? && isAdmin>
                <a href="/${rolePath}/managers/create"
                   class="btn btn-primary rounded-pill px-4 shadow-sm d-flex align-items-center gap-2 fw-medium">
                    <i class="bi bi-person-plus-fill"></i> Додати менеджера
                </a>
            </#if>
        </div>

        <#if successMessage??>
            <div class="alert alert-success alert-dismissible fade show shadow-sm border-0 rounded-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </#if>
        <#if errorMessage??>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0 rounded-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </#if>

        <div class="row g-4">
            <#if managers?has_content>
                <#list managers as manager, currentProjects>
                    <#if manager.user.id != currentUserId>
                        <div class="col-12 col-xl-6">
                        <div class="card manager-card h-100 shadow-sm border rounded-4 d-flex flex-column">

                            <div class="card-body p-4 pb-3">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="d-flex align-items-center gap-3">
                                        <#if manager.user.imageUrl??>
                                            <img src="${manager.user.imageUrl}" class="rounded-circle shadow-sm" style="width: 56px; height: 56px; object-fit: cover;">
                                        <#else>
                                            <div class="bg-primary bg-opacity-10 text-primary border border-primary-subtle rounded-circle d-flex justify-content-center align-items-center fw-bold fs-4 shadow-sm" style="width: 56px; height: 56px;">
                                                ${manager.user.firstName[0]}${manager.user.lastName[0]}
                                            </div>
                                        </#if>

                                        <div class="lh-sm">
                                            <h5 class="fw-bold text-dark mb-1">${manager.user.firstName} ${manager.user.lastName}</h5>
                                            <div class="text-muted small">
                                                <i class="bi bi-envelope me-1"></i>${manager.user.email}
                                            </div>
                                        </div>
                                    </div>

                                    <#if isAdmin?? && isAdmin>
                                        <div class="dropdown">
                                            <button class="btn btn-light btn-sm rounded-circle border shadow-sm d-flex align-items-center justify-content-center" type="button" data-bs-toggle="dropdown" style="width: 32px; height: 32px; padding: 0;">
                                                <i class="bi bi-three-dots-vertical text-muted"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-4 mt-1">
                                                <li>
                                                    <a class="dropdown-item d-flex align-items-center gap-2 py-2 fw-medium" href="/${rolePath}/managers/edit/${manager.id}">
                                                        <i class="bi bi-pencil-fill text-warning"></i> Редагувати
                                                    </a>
                                                </li>
                                                <li><hr class="dropdown-divider opacity-50"></li>
                                                <li>
                                                    <form action="/${rolePath}/managers/delete/${manager.id}" method="post"
                                                          onsubmit="return confirm('Видалити менеджера ${manager.user.firstName?js_string} ${manager.user.lastName?js_string}?');"
                                                          style="display:inline;">
                                                        <button type="submit" class="dropdown-item text-danger d-flex align-items-center gap-2 py-2 fw-medium">
                                                            <i class="bi bi-trash3"></i> Видалити
                                                        </button>
                                                    </form>
                                                </li>
                                            </ul>
                                        </div>
                                    </#if>
                                </div>
                            </div>

                            <div class="mt-auto">
                                <div class="bg-light border-top border-bottom px-4 py-2 small fw-bold text-secondary text-uppercase tracking-wide" style="font-size: 0.75rem;">
                                    <i class="bi bi-briefcase me-1"></i> Поточні проєкти
                                </div>

                                <div class="list-group list-group-flush rounded-bottom-4">
                                    <#if currentProjects?? && currentProjects?size gt 0>
                                        <#list currentProjects as project>
                                            <div class="list-group-item bg-transparent px-4 py-3 border-bottom-0 <#if project?has_next>border-bottom</#if>">
                                                <div class="d-flex justify-content-between align-items-center mb-1">
                                                    <a href="/projects/${project.id}" class="fw-bold text-dark text-decoration-none lh-sm pe-3" style="font-size: 0.95rem; transition: color 0.2s;" onmouseover="this.style.color='#0d6efd'" onmouseout="this.style.color=''">
                                                        ${project.title}
                                                    </a>

                                                    <div>
                                                        <#if project.status == "IN_PROGRESS">
                                                            <span class="badge rounded-pill bg-primary px-2 py-1" style="font-size: 0.7rem;">В процесі</span>
                                                        <#elseif project.status == "COMPLETED">
                                                            <span class="badge rounded-pill bg-success px-2 py-1" style="font-size: 0.7rem;">Завершено</span>
                                                        <#elseif project.status == "INVOICED">
                                                            <span class="badge rounded-pill bg-info text-dark px-2 py-1" style="font-size: 0.7rem;">Рахунок</span>
                                                        <#else>
                                                            <span class="badge rounded-pill bg-secondary px-2 py-1" style="font-size: 0.7rem;">${project.status}</span>
                                                        </#if>
                                                    </div>
                                                </div>

                                                <div class="d-flex gap-3 text-muted mt-2" style="font-size: 0.75rem;">
                                                    <span title="Замовник"><i class="bi bi-building me-1"></i>${project.customer.companyName}</span>
                                                    <span title="Створено"><i class="bi bi-calendar-plus me-1"></i><#if project.createdAt??>${project.getFormattedCreatedAt()}<#else>—</#if></span>
                                                </div>
                                            </div>
                                        </#list>
                                    <#else>
                                        <div class="px-4 py-4 text-center text-muted small bg-white rounded-bottom-4">
                                            <i class="bi bi-inbox fs-4 d-block mb-2 opacity-50"></i>
                                            Немає активних проєктів
                                        </div>
                                    </#if>
                                </div>
                            </div>

                        </div>
                    </div>
                    </#if>
                </#list>
            <#else>
                <div class="col-12 text-center py-5 bg-white rounded-4 shadow-sm border mt-2">
                    <i class="bi bi-person-video2 text-secondary opacity-25" style="font-size: 3rem;"></i>
                    <h5 class="fw-medium text-dark mt-3" style="font-size: 1.1rem;">Менеджерів поки немає</h5>
                    <p class="text-muted small mt-1 mb-0">Тут відображатиметься команда управління та їхні проєкти.</p>
                </div>
            </#if>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>