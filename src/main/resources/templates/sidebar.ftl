<div class="sidebar d-flex flex-column p-3">
    <a href="/${rolePath}/welcome" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white">
        <span class="fs-4 fw-bold">DevSync</span>
    </a>
    <hr>
    <ul class="nav nav-pills flex-column h-100 bg-dark">
        <div class="flex-grow-1">
            <#if isAuth ?? && (isAdmin?? && isAdmin) || (isManager?? && isManager) || (isDeveloper?? && isDeveloper)>
                <li><a href="/${rolePath}/developers" class="nav-link">Розробники</a></li>
                <li><a href="/${rolePath}/managers" class="nav-link">Менеджери</a></li>
                <li><a href="/${rolePath}/customers" class="nav-link">Замовники</a></li>
            </#if>
            <li><a href="/${rolePath}/projects" class="nav-link">Проєкти</a></li>
            <li><a href="/${rolePath}/project-assignments" class="nav-link">Завдання проєкту</a></li>

            <#if isAuth ?? && !(isDeveloper?? && isDeveloper)>
                <li><a href="/${rolePath}/invoices" class="nav-link">Рахунки</a></li>
            </#if>
        </div>

        <hr>

        <div>
<#--            <li>-->
<#--                <a href="/${rolePath}/profile" class="nav-link d-flex align-items-center gap-2">-->
<#--                    <i class="bi bi-person-circle"></i> Мій профіль-->
<#--                </a>-->
<#--            </li>-->
            <li>
                <a href="/logout" class="nav-link text-danger d-flex align-items-center gap-2">
                    <i class="bi bi-box-arrow-right text-danger"></i> Вийти
                </a>
            </li>
        </div>
    </ul>
</div>