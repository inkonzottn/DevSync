<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>Редагувати завдання | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        body { background-color: #f8f9fa; }
        .card { border: none; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .form-label { font-weight: 600; color: #495057; }
    </style>
</head>
<body class="d-flex">


<div class="main-content flex-grow-1 p-4">
    <div class="container max-w-75">
        <div class="d-flex align-items-center mb-4 pb-2 border-bottom">
            <a href="/developer/project-assignments" class="btn btn-light rounded-circle me-3 shadow-sm text-secondary">
                <i class="bi bi-arrow-left"></i>
            </a>
            <div>
                <h2 class="fw-bold m-0">Редагувати завдання</h2>
                <p class="text-muted small mb-0 mt-1">Змініть назву або уточніть опис роботи</p>
            </div>
        </div>

        <#if message??>
            <div class="alert alert-danger rounded-3 shadow-sm d-flex align-items-center">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                <div>${message}</div>
            </div>
        </#if>

        <div class="card p-4 border-top border-4 border-warning">
            <form action="/developer/project-assignments/edit/${assignment.id}" method="post">

                <div class="mb-4">
                    <label class="form-label text-muted"><i class="bi bi-folder2-open me-1"></i> Проєкт</label>
                    <input type="text" class="form-control bg-light text-muted border-dashed" value="${assignment.project.title}" disabled>
                    <div class="form-text small">Завдання прив'язане до цього проєкту. Змінити проєкт неможливо.</div>
                </div>

                <div class="mb-4">
                    <label class="form-label">Назва завдання</label>
                    <input type="text" name="title" value="${(assignment.title)!''}"
                           class="form-control <#if errors?? && errors['title']??>is-invalid</#if>"
                           placeholder="Наприклад: Налаштування бази даних">
                    <#if errors?? && errors['title']??>
                        <div class="invalid-feedback fw-medium"><i class="bi bi-x-circle me-1"></i>${errors['title']}</div>
                    </#if>
                </div>

                <div class="mb-4">
                    <label class="form-label">Опис та деталі</label>
                    <textarea name="description" rows="5"
                              class="form-control <#if errors?? && errors['description']??>is-invalid</#if>"
                              placeholder="Опишіть детально, що саме було зроблено...">${(assignment.description)!''}</textarea>
                    <#if errors?? && errors['description']??>
                        <div class="invalid-feedback fw-medium"><i class="bi bi-x-circle me-1"></i>${errors['description']}</div>
                    </#if>
                </div>

                <div class="d-flex justify-content-end gap-2 pt-4 border-top mt-2">
                    <a href="/developer/project-assignments" class="btn btn-light px-4 border text-dark fw-medium">Скасувати</a>
                    <button type="submit" class="btn btn-warning text-dark fw-bold px-4 shadow-sm d-flex align-items-center gap-2">
                        <i class="bi bi-floppy-fill"></i> Зберегти зміни
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>