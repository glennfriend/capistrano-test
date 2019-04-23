<?php

use Illuminate\Support\Facades\Route;
use Cor\PrivateInfo\Http\Middleware\IpCheckMiddleware;

Route::group([
        'prefix' => 'private-info',
        'middleware' => IpCheckMiddleware::class
    ] , function () {

    /*
    Route::get('/phpinfo', 'HomeController@index')
        ->name('private_info.home.index');
    */
    Route::get('/phpinfo',  'HomeController@index');

    // --------------------------------------------------------------------------------
    //  第三方程式
    //      - https://packagist.org/packages/rap2hpoutre/laravel-log-viewer
    //      - laravel log viewer
    //      - composer "rap2hpoutre/laravel-log-viewer"
    // --------------------------------------------------------------------------------
    Route::get('/logs', '\Rap2hpoutre\LaravelLogViewer\LogViewerController@index');

});
