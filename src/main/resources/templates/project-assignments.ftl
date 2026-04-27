<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Завдання проєкту | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body class="d-flex bg-light">

<#include "sidebar.ftl">

<div class="main-content flex-grow-1 p-4">
    <div class="container-fluid" style="max-width: 1200px;">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold m-0 text-dark">Робочі завдання</h2>
                <p class="text-muted small mb-0 mt-1">Історія роботи над проєктами та закриті години</p>
            </div>

            <#if isAuth?? && isDeveloper?? && isDeveloper && hasActiveProject?? && hasActiveProject>
                <a href="/developer/project-assignments/create"
                   class="btn btn-primary shadow-sm rounded-pill px-4 fw-medium d-flex align-items-center gap-2">
                    <i class="bi bi-plus-lg"></i> Почати завдання
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

        <#if projectAssignments?? && projectAssignments?has_content>

            <#assign uniqueProjects = []>
            <#assign uniqueProjectIds = []>
            <#list projectAssignments as a>
                <#if !uniqueProjectIds?seq_contains(a.project.id)>
                    <#assign uniqueProjectIds = uniqueProjectIds + [a.project.id]>
                    <#assign uniqueProjects = uniqueProjects + [a.project]>
                </#if>
            </#list>

            <#list uniqueProjects as proj>

                <div class="mb-4 bg-white p-4 rounded-4 shadow-sm border">
                    <div class="fw-bold text-dark mb-3 d-flex align-items-center gap-2" style="font-size: 1.1rem;">
                        <i class="bi bi-folder2-open text-primary"></i> ${proj.title}
                    </div>

                    <#assign activeTasks = projectAssignments?filter(a -> a.project.id == proj.id && a.active)>
                    <#assign completedTasks = projectAssignments?filter(a -> a.project.id == proj.id && !a.active)>

                    <#if activeTasks?has_content>
                        <div class="small text-uppercase text-secondary fw-bold mb-2" style="font-size: 0.75rem; letter-spacing: 0.5px;">
                            <i class="bi bi-play-circle me-1"></i> В роботі
                        </div>
                        <div class="row g-3 mb-4">
                            <#list activeTasks as assignment>
                                <div class="col-12 col-md-6 col-xl-4">
                                    <div class="card h-100 border-0 border-start border-4 border-primary shadow-sm bg-white rounded-3" style="transition: transform 0.2s ease;">
                                        <div class="card-body p-3 d-flex flex-column">

                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <div class="fw-bold text-dark lh-sm pe-2" style="font-size: 0.95rem;">${assignment.title}</div>

                                                <#if isAuth??>
                                                    <div class="dropdown">
                                                        <button class="btn btn-light btn-sm rounded-circle border shadow-sm d-flex align-items-center justify-content-center" type="button" data-bs-toggle="dropdown" style="width: 28px; height: 28px; padding: 0;">
                                                            <i class="bi bi-three-dots-vertical text-muted" style="font-size: 0.8rem;"></i>
                                                        </button>
                                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-4 mt-1">
                                                            <#if isDeveloper?? && isDeveloper>
                                                                <li>
                                                                    <button type="button" class="dropdown-item fw-medium text-success d-flex align-items-center gap-2 py-2" onclick="openFinishModal(${assignment.id}, '${assignment.title?js_string}')">
                                                                        <i class="bi bi-check2-square"></i> Завершити
                                                                    </button>
                                                                </li>
                                                                <li>
                                                                    <a class="dropdown-item d-flex align-items-center gap-2 py-2 fw-medium" href="/developer/project-assignments/edit/${assignment.id}">
                                                                        <i class="bi bi-pencil-fill text-warning"></i> Редагувати
                                                                    </a>
                                                                </li>
                                                            </#if>
                                                            <#if isAdmin?? && isAdmin>
                                                                <li><hr class="dropdown-divider opacity-50"></li>
                                                                <li>
                                                                    <form action="/admin/project-assignments/delete/${assignment.id}" method="post" onsubmit="return confirm('Видалити завдання?');">
                                                                        <button type="submit" class="dropdown-item text-danger d-flex align-items-center gap-2 py-2 fw-medium">
                                                                            <i class="bi bi-trash3"></i> Видалити
                                                                        </button>
                                                                    </form>
                                                                </li>
                                                            </#if>
                                                        </ul>
                                                    </div>
                                                </#if>
                                            </div>

                                            <div class="text-secondary mb-3 flex-grow-1" style="font-size: 0.85rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                                ${assignment.description!''}
                                            </div>

                                            <div class="mt-auto border-top pt-2">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <#if assignment.developer.user.imageUrl??>
                                                            <img src="${assignment.developer.user.imageUrl}" class="rounded-circle shadow-sm" style="width: 32px; height: 32px; object-fit: cover;">
                                                        <#else>
                                                            <div class="bg-light text-secondary border rounded-circle d-flex justify-content-center align-items-center fw-bold" style="width: 32px; height: 32px; font-size: 0.8rem;">
                                                                ${assignment.developer.user.firstName[0]}${assignment.developer.user.lastName[0]}
                                                            </div>
                                                        </#if>
                                                        <div class="lh-1">
                                                            <span class="fw-semibold text-dark d-block mb-1" style="font-size: 0.85rem;">${assignment.developer.user.firstName}</span>
                                                            <span class="badge bg-primary bg-opacity-10 text-primary border border-primary-subtle rounded-pill" style="font-size: 0.65rem;">В процесі</span>
                                                        </div>
                                                    </div>
                                                    <div class="text-muted" style="font-size: 0.75rem;">
                                                        <i class="bi bi-calendar-event"></i> ${assignment.formattedCreatedAt}
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </#list>
                        </div>
                    </#if>

                    <#if completedTasks?has_content>
                        <div class="text-success text-uppercase fw-bold mb-2 <#if activeTasks?has_content>mt-3</#if>" style="font-size: 0.75rem; letter-spacing: 0.5px;">
                            <i class="bi bi-check-all me-1"></i> Завершено
                        </div>
                        <div class="row g-3">
                            <#list completedTasks as assignment>
                                <div class="col-12 col-md-6 col-xl-4">
                                    <div class="card h-100 border-0 border-start border-4 border-success shadow-sm bg-light rounded-3" style="opacity: 0.85;">
                                        <div class="card-body p-3 d-flex flex-column">

                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <div class="fw-bold text-secondary lh-sm pe-2 text-decoration-line-through" style="font-size: 0.95rem;">${assignment.title}</div>

                                                <#if isAdmin?? && isAdmin>
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm rounded-circle border bg-white d-flex align-items-center justify-content-center" type="button" data-bs-toggle="dropdown" style="width: 28px; height: 28px; padding: 0;">
                                                            <i class="bi bi-three-dots-vertical text-muted" style="font-size: 0.8rem;"></i>
                                                        </button>
                                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-4 mt-1">
                                                            <li>
                                                                <form action="/admin/project-assignments/delete/${assignment.id}" method="post" onsubmit="return confirm('Видалити завдання?');">
                                                                    <button type="submit" class="dropdown-item text-danger d-flex align-items-center gap-2 py-2 fw-medium">
                                                                        <i class="bi bi-trash3"></i> Видалити
                                                                    </button>
                                                                </form>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </#if>
                                            </div>

                                            <div class="text-muted mb-3 flex-grow-1" style="font-size: 0.85rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                                ${assignment.description!''}
                                            </div>

                                            <div class="mt-auto border-top border-secondary-subtle pt-2">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <div class="bg-white text-secondary border rounded-circle d-flex justify-content-center align-items-center fw-bold" style="width: 32px; height: 32px; font-size: 0.8rem;">
                                                            ${assignment.developer.user.firstName[0]}${assignment.developer.user.lastName[0]}
                                                        </div>
                                                        <div class="lh-1">
                                                            <span class="fw-semibold text-secondary d-block mb-1" style="font-size: 0.85rem;">${assignment.developer.user.firstName}</span>
                                                            <span class="badge bg-success bg-opacity-10 text-success border border-success-subtle rounded-pill" style="font-size: 0.65rem;">${assignment.spentHours!0}г ${assignment.spentMinutes!0}хв</span>
                                                        </div>
                                                    </div>
                                                    <div class="text-muted" style="font-size: 0.75rem;">
                                                        <i class="bi bi-calendar-check text-success"></i> ${assignment.formattedCompletedAt!''}
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </#list>
                        </div>
                    </#if>

                </div>
            </#list>

        <#else>
            <div class="text-center py-5 bg-white rounded-4 shadow-sm border mt-4">
                <i class="bi bi-clipboard-x text-secondary opacity-25" style="font-size: 3rem;"></i>
                <h5 class="fw-medium text-dark mt-3" style="font-size: 1.1rem;">Поки що немає жодних завдань</h5>
                <p class="text-muted small mt-1 mb-0">Тут з'явиться історія виконаних робіт по проєктах.</p>
            </div>
        </#if>
    </div>
</div>

<div class="modal fade" id="finishTaskModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-bottom-0 pb-0">
                <h6 class="modal-title fw-bold text-success"><i class="bi bi-check-circle-fill me-2"></i>Завершення роботи</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form id="finishTaskForm" method="post" action="">
                <div class="modal-body pb-2">
                    <p class="text-muted mb-3" style="font-size: 0.85rem;">Завдання: <strong id="finishTaskTitle" class="text-dark"></strong></p>

                    <label class="form-label fw-medium text-dark mb-2" style="font-size: 0.9rem;">Витрачений час:</label>
                    <div class="row g-2">
                        <div class="col-6">
                            <div class="input-group shadow-sm">
                                <input type="number" name="spentHours" class="form-control border-end-0" min="0" max="999" value="0" required>
                                <span class="input-group-text bg-white text-muted small">год</span>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="input-group shadow-sm">
                                <input type="number" name="spentMinutes" class="form-control border-end-0" min="0" max="59" value="0" required>
                                <span class="input-group-text bg-white text-muted small">хв</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-top-0 pt-2 pb-3 px-3 d-flex justify-content-between">
                    <button type="button" class="btn btn-sm btn-light rounded-pill px-3" data-bs-dismiss="modal">Скасувати</button>
                    <button type="submit" class="btn btn-sm btn-success rounded-pill px-4 shadow-sm fw-medium">Підтвердити</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openFinishModal(taskId, taskTitle) {
        document.getElementById('finishTaskForm').action = '/developer/project-assignments/finish/' + taskId;
        document.getElementById('finishTaskTitle').innerText = taskTitle;
        var myModal = new bootstrap.Modal(document.getElementById('finishTaskModal'));
        myModal.show();
    }
</script>

</body>
</html>