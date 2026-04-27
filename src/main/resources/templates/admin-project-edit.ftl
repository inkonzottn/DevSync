<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Редагування проєкту | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .card { border: none; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .form-label { font-weight: 600; color: #495057; }
        .btn-save { background: #0d6efd; color: white; border-radius: 10px; padding: 10px 25px; transition: 0.3s; }
        .btn-save:hover { background: #0b5ed7; }
        .manager-select { border-color: #0d6efd; box-shadow: 0 0 0 0.1rem rgba(13, 110, 253, 0.1); }
    </style>
</head>
<body class="d-flex">

<div class="main-content flex-grow-1 p-4">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">

                <div class="d-flex align-items-center mb-4">
                    <a href="/admin/projects" class="btn btn-light rounded-circle me-3">
                        <i class="bi bi-arrow-left"></i>
                    </a>
                    <h2 class="fw-bold m-0">Редагування проєкту #${project.id}</h2>
                </div>

                <#if message??>
                    <div class="alert alert-danger border-0 rounded-3 shadow-sm mb-4">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${message}
                    </div>
                </#if>

                <div class="card p-4">
                    <form action="/admin/projects/edit/${project.id}" method="post">

                        <div class="mb-4">
                            <label class="form-label">Назва проєкту</label>
                            <input type="text" name="title"
                                   class="form-control <#if errors?? && errors['title']??>is-invalid</#if>"
                                   value="${(project.title)!''}" placeholder="Наприклад: Розробка CRM системи">
                            <#if errors?? && errors['title']??>
                                <div class="invalid-feedback">${errors['title']}</div>
                            </#if>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Опис та вимоги</label>
                            <textarea name="description" rows="5"
                                      class="form-control <#if errors?? && errors['description']??>is-invalid</#if>"
                                      placeholder="Опишіть детально, що саме потрібно зробити...">${(project.description)!''}</textarea>
                            <#if errors?? && errors['description']??>
                                <div class="invalid-feedback">${errors['description']}</div>
                            </#if>
                        </div>

                        <div class="row mb-4 bg-light p-3 rounded-3 mx-0">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <label class="form-label text-primary"><i class="bi bi-person-fill-gear me-1"></i> Призначити менеджера</label>
                                <select name="managerId" class="form-select manager-select">
                                    <option value="">-- Не призначено --</option>
                                    <#list managers as manager>
                                        <option value="${manager.id}"
                                                <#if project.manager?? && project.manager.id == manager.id>selected</#if>>
                                            ${manager.user.firstName} ${manager.user.lastName}
                                        </option>
                                    </#list>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label"><i class="bi bi-tag-fill me-1 text-muted"></i> Статус проєкту</label>
                                <select name="status" class="form-select border-secondary">
                                    <#list statuses as status>
                                        <option value="${status.name()}"
                                                <#if project.status?? && project.status.name() == status.name()>selected</#if>>
                                            ${status.name()}
                                        </option>
                                    </#list>
                                </select>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2 mt-2 pt-3 border-top">
                            <a href="/admin/projects" class="btn btn-light px-4">Скасувати</a>
                            <button type="submit" class="btn btn-save">Зберегти зміни</button>
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