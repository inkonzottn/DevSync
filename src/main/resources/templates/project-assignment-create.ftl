<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Почати завдання | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .card { border: none; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .form-label { font-weight: 600; color: #495057; }
        .btn-primary { border-radius: 10px; padding: 10px 25px; }
    </style>
</head>
<body class="d-flex">


<div class="main-content flex-grow-1 p-4">
    <div class="container max-w-75">
        <div class="d-flex align-items-center mb-4">
            <a href="/developer/project-assignments" class="btn btn-light rounded-circle me-3 shadow-sm"><i class="bi bi-arrow-left"></i></a>
            <h2 class="fw-bold m-0">Нове завдання</h2>
        </div>

        <#if message??>
            <div class="alert alert-danger rounded-3 shadow-sm"><i class="bi bi-exclamation-circle me-2"></i>${message}</div>
        </#if>

        <div class="card p-4">
            <form action="/developer/project-assignments/create" method="post">

                <div class="mb-4">
                    <label class="form-label text-muted"><i class="bi bi-folder2-open me-1"></i> Поточний проєкт</label>
                    <input type="text" class="form-control bg-light text-muted" value="${currentProject.title}" readonly>

                    <input type="hidden" name="project.id" value="${currentProject.id}">
                </div>

                <div class="mb-4">
                    <label class="form-label">Назва завдання (що будете робити?)</label>
                    <input type="text" name="title" value="${(assignment.title)!''}" class="form-control <#if errors?? && errors['title']??>is-invalid</#if>">
                    <#if errors?? && errors['title']??><div class="invalid-feedback">${errors['title']}</div></#if>
                </div>

                <div class="mb-4">
                    <label class="form-label">Опис та деталі</label>
                    <textarea name="description" rows="4" class="form-control <#if errors?? && errors['description']??>is-invalid</#if>">${(assignment.description)!''}</textarea>
                    <#if errors?? && errors['description']??><div class="invalid-feedback">${errors['description']}</div></#if>
                </div>


                <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                    <a href="/developer/project-assignments" class="btn btn-light px-4 border">Скасувати</a>
                    <button type="submit" class="btn btn-primary shadow-sm"><i class="bi bi-play-circle me-1"></i> Почати роботу</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>