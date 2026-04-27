<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Управління проєктом | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .card { border: none; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .form-label { font-weight: 600; color: #495057; }
        .btn-save { background: #0d6efd; color: white; border-radius: 10px; padding: 10px 25px; transition: 0.3s; }
        .btn-save:hover { background: #0b5ed7; }
        .dev-list-container { max-height: 220px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 0.5rem; background-color: #ffffff; padding: 15px; }
        .dev-list-container::-webkit-scrollbar { width: 6px; }
        .dev-list-container::-webkit-scrollbar-thumb { background-color: #ccc; border-radius: 10px; }
    </style>
</head>
<body class="d-flex">

<div class="main-content flex-grow-1 p-4">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-9 col-xl-8">

                <div class="d-flex align-items-center mb-4">
                    <a href="/manager/projects" class="btn btn-light rounded-circle me-3 shadow-sm">
                        <i class="bi bi-arrow-left"></i>
                    </a>
                    <h2 class="fw-bold m-0">Управління командою проєкту #${project.id}</h2>
                </div>

                <#if message??>
                    <div class="alert alert-danger border-0 rounded-3 shadow-sm mb-4">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${message}
                    </div>
                </#if>

                <div class="card p-4">
                    <form action="/manager/projects/edit/${project.id}" method="post">

                        <div class="mb-4">
                            <label class="form-label">Назва проєкту</label>
                            <input type="text" name="title"
                                   class="form-control <#if errors?? && errors['title']??>is-invalid</#if>"
                                   value="${(project.title)!''}">
                            <#if errors?? && errors['title']??>
                                <div class="invalid-feedback">${errors['title']}</div>
                            </#if>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Опис та вимоги</label>
                            <textarea name="description" rows="4"
                                      class="form-control <#if errors?? && errors['description']??>is-invalid</#if>">${(project.description)!''}</textarea>
                            <#if errors?? && errors['description']??>
                                <div class="invalid-feedback">${errors['description']}</div>
                            </#if>
                        </div>

                        <div class="row mb-4 bg-light p-3 rounded-3 mx-0 border">

                            <div class="col-md-7 mb-3 mb-md-0">
                                <label class="form-label text-primary"><i class="bi bi-people-fill me-1"></i> Додати вільних розробників</label>
                                <div class="dev-list-container shadow-sm">
                                    <#if freeDevelopers?? && freeDevelopers?has_content>
                                        <#list freeDevelopers as dev>
                                            <div class="form-check mb-2 pb-2 border-bottom">
                                                <input class="form-check-input mt-2" type="checkbox" name="developerIds" value="${dev.id}" id="dev${dev.id}">
                                                <label class="form-check-label d-flex justify-content-between align-items-center w-100 pe-2 cursor-pointer" for="dev${dev.id}">
                                                    <span class="fw-medium">${dev.user.firstName} ${dev.user.lastName}</span>
                                                    <#-- Заглушка для спеціалізації, якщо вона є в сутності -->
                                                    <span class="badge bg-secondary rounded-pill bg-opacity-75" style="font-size: 0.75rem;">${(dev.specialization)!'Розробник'}</span>
                                                </label>
                                            </div>
                                        </#list>
                                    <#else>
                                        <div class="text-muted small p-3 text-center">
                                            <i class="bi bi-cup-hot fs-4 d-block mb-2"></i>
                                            Усі розробники зараз зайняті на інших проєктах
                                        </div>
                                    </#if>
                                </div>
                            </div>

                            <div class="col-md-5 d-flex flex-column">
                                <label class="form-label"><i class="bi bi-tag-fill me-1 text-muted"></i> Статус проєкту</label>
                                <select name="status" class="form-select border-secondary shadow-sm mb-4">
                                    <#list statuses as status>
                                        <option value="${status.name()}"
                                                <#if project.status?? && project.status.name() == status.name()>selected</#if>>
                                            ${status.name()}
                                        </option>
                                    </#list>
                                </select>

                                <#if project.developers?? && project.developers?has_content>
                                    <label class="form-label"><i class="bi bi-person-check-fill me-1 text-success"></i> Вже в команді:</label>
                                    <div class="d-flex flex-wrap gap-2">
                                        <#list project.developers as currentDev>
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success-subtle p-2">
                                                <i class="bi bi-check-circle me-1"></i> ${currentDev.user.firstName} ${currentDev.user.lastName}
                                            </span>
                                        </#list>
                                    </div>
                                </#if>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                            <a href="/manager/projects" class="btn btn-light px-4 border">Скасувати</a>
                            <button type="submit" class="btn btn-save shadow-sm">Зберегти зміни</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>