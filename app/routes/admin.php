<?php

use App\Http\Controllers\Admin\AdminDashboardController;
use Illuminate\Support\Facades\Route;

Route::prefix("admin")->name("admin.")->group(function() {
    Route::get("dashboard", [AdminDashboardController::class,
        "index"])->name("dashboard");
});

