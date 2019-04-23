<?php

namespace Cor\PrivateInfo;

use Illuminate\Support\Facades\Route;
use Illuminate\Support\ServiceProvider;
use Illuminate\Contracts\Events\Dispatcher;

class PrivateInfoServiceProvider extends ServiceProvider
{

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        $this->registerRoutes();
    }

    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        /*
        if (! defined('PRIVATE_INFO_PATH')) {
            define('PRIVATE_INFO_PATH', realpath(__DIR__.'/../'));
        }
        */

        $this->configure();
        $this->offerPublishing();
    }

    // --------------------------------------------------------------------------------
    //  private
    // --------------------------------------------------------------------------------

    /**
     * Register the Horizon routes.
     *
     * @return void
     */
    protected function registerRoutes()
    {
        Route::group([
            //'prefix' => config('private_info.uri', 'private_info'),
            'namespace' => 'Cor\PrivateInfo\Http\Controllers',
            //'middleware' => config('private_info.middleware', 'web'),
        ], function () {
            $this->loadRoutesFrom(__DIR__ . '/../publish_files/routes/web.php');
        });
    }

    /**
     * Setup the configuration for Horizon.
     *
     * @return void
     */
    protected function configure()
    {
        $this->mergeConfigFrom(
            __DIR__ . '/../publish_files/config/private_info.php', 'private_info'
        );

        //PrivateInfo::use(config('private_info.use'));
    }

    /**
     * 發佈資源檔
     *      - config/
     *
     * @return void
     */
    protected function offerPublishing()
    {
        if ($this->app->runningInConsole()) {
            $this->publishes([
                __DIR__ . '/../publish_files/config/private_info.php' => config_path('private_info.php'),
            ], 'private_info-config');
        }
    }

}
