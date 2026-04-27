<#macro pages>
    <!DOCTYPE html>
    <html lang="uk">
    <head>
        <meta charset="UTF-8">
        <title>DevSync | Команда розробників</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body { background-color: #f8f9fa; }
            .navbar { margin-bottom: 20px; }
        </style>
    </head>
    <body>

    <nav class="navbar navbar-expand-lg navbar-light py-4">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center fw-bold fs-3 text-dark" href="/">
                <div class="logo-box me-2"></div> DevSync
            </a>
            <div class="ms-auto d-flex align-items-center gap-3">
                <#if isAuth>
                    <span class="text-muted">Вітаємо, ${username}!</span>
                    <a href="/logout" class="btn btn-link text-decoration-none text-dark p-0">Вийти</a>
                    <a href="/${rolePath}/welcome" class="btn btn-primary px-4 rounded-pill shadow-sm">До роботи!</a>
                <#else>
                    <a href="/login" class="btn btn-link text-decoration-none text-dark p-0">Увійти</a>
                    <a href="/registration" class="btn btn-primary px-4 rounded-pill shadow-sm">Зареєструватись</a>
                </#if>
            </div>
        </div>
    </nav>

    <div class="container">
        <#nested> </div>

    <footer class="text-center mt-2 py-3 text-muted">
        <p>&copy; 2026 Команда розробників — Курсовий проєкт</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>
</#macro>