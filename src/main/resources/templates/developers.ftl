<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Розробники | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        /* Залізобетонний фікс сайдбару та контенту */
        .sidebar { flex-shrink: 0 !important; }
        .main-content { min-width: 0; overflow-x: hidden; }
        .dev-card { transition: transform 0.2s ease; }
        .dev-card:hover { transform: translateY(-2px); }
    </style>
</head>
<body class="d-flex bg-light">

<#include "sidebar.ftl">

<div class="main-content flex-grow-1 p-4" style="min-width: 0;">
    <div class="container-fluid" style="max-width: 1200px;">

        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-start align-items-sm-center gap-3 mb-4">
            <div>
                <h2 class="fw-bold m-0 text-dark">Розробники</h2>
                <p class="text-muted small mb-0 mt-1">Команда інженерів та їхні поточні завдання</p>
            </div>

            <#if isAdmin?? && isAdmin>
                <a href="/${rolePath}/developers/create"
                   class="btn btn-primary rounded-pill px-4 shadow-sm d-flex align-items-center gap-2 fw-medium">
                    <i class="bi bi-person-plus-fill"></i> Додати розробника
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
            <#if developers?has_content>
                <#assign hasVisibleDevs = false>
                <#list developers as developer>
                    <#if developer.user.id != currentUserId>
                        <#assign hasVisibleDevs = true>
                        <div class="col-12 col-xl-6">
                            <div class="card dev-card h-100 shadow-sm border rounded-4 d-flex flex-column">

                                <div class="card-body p-4 pb-0">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <#if developer.imageUrl??>
                                                <img src="${developer.imageUrl}" class="rounded-circle shadow-sm" style="width: 56px; height: 56px; object-fit: cover;">
                                            <#else>
                                                <div class="bg-primary bg-opacity-10 text-primary border border-primary-subtle rounded-circle d-flex justify-content-center align-items-center fw-bold fs-4 shadow-sm" style="width: 56px; height: 56px;">
                                                    ${developer.user.firstName[0]}${developer.user.lastName[0]}
                                                </div>
                                            </#if>

                                            <div class="lh-sm">
                                                <h5 class="fw-bold text-dark mb-1">${developer.user.firstName} ${developer.user.lastName}</h5>
                                                <div class="text-muted small">
                                                    <i class="bi bi-envelope me-1"></i>${developer.user.email}
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
                                                        <a class="dropdown-item d-flex align-items-center gap-2 py-2 fw-medium" href="/${rolePath}/developers/edit/${developer.id}">
                                                            <i class="bi bi-pencil-fill text-warning"></i> Редагувати
                                                        </a>
                                                    </li>
                                                    <li><hr class="dropdown-divider opacity-50"></li>
                                                    <li>
                                                        <form action="/${rolePath}/developers/delete/${developer.id}" method="post"
                                                              onsubmit="return confirm('Ви впевнені, що хочете видалити розробника ${developer.user.firstName?js_string} ${developer.user.lastName?js_string}?');"
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

                                    <div class="d-flex flex-wrap gap-2 mb-3">
                                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary-subtle px-2 py-1">
                                            <i class="bi bi-code-slash me-1"></i>${developer.specialization}
                                        </span>
                                        <span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary-subtle px-2 py-1">
                                            <i class="bi bi-stars me-1"></i>${developer.qualification}
                                        </span>
                                        <span class="badge bg-success bg-opacity-10 text-success border border-success-subtle px-2 py-1">
                                            ${developer.hourlyRate}грн/год
                                        </span>
                                    </div>

<#--                                    <div class="mb-4">-->
<#--                                        <div class="text-uppercase text-secondary fw-bold mb-2 tracking-wide" style="font-size: 0.7rem;">Технології</div>-->
<#--                                        <div class="d-flex flex-wrap gap-1">-->
<#--                                            <#if developer.skills?? && developer.skills?has_content>-->
<#--                                                <#list developer.skills as skill>-->
<#--                                                    <span class="badge bg-white border text-secondary fw-medium px-2 py-1 shadow-sm" style="font-size: 0.75rem;">${skill.name}</span>-->
<#--                                                </#list>-->
<#--                                            <#else>-->
<#--                                                <span class="text-muted small fst-italic">Скіли не вказані</span>-->
<#--                                            </#if>-->
<#--                                        </div>-->
<#--                                    </div>-->
                                </div>

                                <div class="mt-auto bg-light border-top rounded-bottom-4 p-4">
                                    <div class="small fw-bold text-secondary text-uppercase tracking-wide mb-2" style="font-size: 0.75rem;">
                                        <i class="bi bi-laptop me-1"></i> Поточний проєкт
                                    </div>

                                    <#if developer.currentProject??>
                                        <div class="bg-white p-3 rounded-3 border shadow-sm" style="transition: transform 0.2s ease;">
                                            <div class="d-flex justify-content-between align-items-start mb-1">
                                                <a href="/projects/${developer.currentProject.id}" class="fw-bold text-dark text-decoration-none lh-sm pe-3" style="font-size: 0.95rem; transition: color 0.2s;" onmouseover="this.style.color='#0d6efd'" onmouseout="this.style.color=''">
                                                    ${developer.currentProject.title}
                                                </a>

                                                <div>
                                                    <#if developer.currentProject.status == "PROPOSAL">
                                                        <span class="badge rounded-pill bg-warning text-dark px-2 py-1" style="font-size: 0.7rem;">Пропозиція</span>
                                                    <#elseif developer.currentProject.status == "IN_PROGRESS">
                                                        <span class="badge rounded-pill bg-primary px-2 py-1" style="font-size: 0.7rem;">В процесі</span>
                                                    <#elseif developer.currentProject.status == "COMPLETED">
                                                        <span class="badge rounded-pill bg-success px-2 py-1" style="font-size: 0.7rem;">Завершено</span>
                                                    <#elseif developer.currentProject.status == "INVOICED">
                                                        <span class="badge rounded-pill bg-info text-dark px-2 py-1" style="font-size: 0.7rem;">Рахунок</span>
                                                    <#else>
                                                        <span class="badge rounded-pill bg-secondary px-2 py-1" style="font-size: 0.7rem;">${developer.currentProject.status}</span>
                                                    </#if>
                                                </div>
                                            </div>

                                            <div class="d-flex gap-3 text-muted mt-2" style="font-size: 0.75rem;">
                                                <span title="Замовник"><i class="bi bi-building me-1"></i>${developer.currentProject.customer.companyName!"PERSONAL"}</span>
                                            </div>
                                        </div>
                                    <#else>
                                        <div class="bg-success bg-opacity-10 text-success border border-success-subtle rounded-3 p-3 text-center fw-medium shadow-sm">
                                            <i class="bi bi-cup-hot me-2"></i> Вільний
                                        </div>
                                    </#if>
                                </div>

                            </div>
                        </div>
                    </#if>
                </#list>

                <#if !hasVisibleDevs>
                    <div class="col-12 text-center py-5 bg-white rounded-4 shadow-sm border mt-2">
                        <i class="bi bi-person-slash text-secondary opacity-25" style="font-size: 3rem;"></i>
                        <h5 class="fw-medium text-dark mt-3" style="font-size: 1.1rem;">Інших розробників поки немає</h5>
                    </div>
                </#if>

            <#else>
                <div class="col-12 text-center py-5 bg-white rounded-4 shadow-sm border mt-2">
                    <i class="bi bi-code-slash text-secondary opacity-25" style="font-size: 3rem;"></i>
                    <h5 class="fw-medium text-dark mt-3" style="font-size: 1.1rem;">Розробників поки немає</h5>
                    <p class="text-muted small mt-1 mb-0">Тут відображатиметься команда інженерів.</p>
                </div>
            </#if>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>