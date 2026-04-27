<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Панель управління | DevSync</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/style.css">
</head>
<body class="d-flex">

<#include "../sidebar.ftl">

<div class="main-content">
    <div class="container-fluid">
        <h2 class="mb-4 fw-bold">Привіт ${username!"Користувач"} 😎</h2>
        <h4 class="mb-4 fw-bold" style="color: #6c757d">
            Ласкаво просимо до кабінету
            <span class="text-primary">
                <#if isAdmin?? && isAdmin>Адміністратора
                <#elseif isManager?? && isManager>Менеджера
                <#elseif isDeveloper?? && isDeveloper>Розробника
                <#else>Замовника
                </#if>
            </span>!
        </h4>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>