#!/usr/bin/php
<?php

function show($content)
{
    if ($content) {
        $left   = "\033[1;33m";
        $right  = "\033[0m";
        echo "{$left}---- {$content} ----{$right}";
    }
    echo "\n";
}

function perform($commands)
{
    foreach ($commands as $item) {

        $title   = isset($item['title']) ? $item['title'] : '';
        $command = isset($item['cmd'])   ? $item['cmd']   : '';
        $funt    = isset($item['funt'])  ? $item['funt']  : '';

        show($title);
        if ($command) {
            system($command);
        }
        elseif ($funt) {
            $funt();
        }

        echo "\n";
    }
    exit;
}

/**
 * 改變 檔案、目錄 的可寫權限
 */
function laravel_folders_and_permission()
{
    $dir = __DIR__;

    $command = "mkdir -p {$dir}/storage";
    echo "> " . $command . "\n";
    system($command);

    $command = "chmod -R 777 {$dir}/storage";
    echo "> " . $command . "\n";
    system($command);

    $command = "chmod -R 777 {$dir}/bootstrap/cache";
    echo "> " . $command . "\n";
    system($command);
}

/**
 *
 */
perform([
    [
        'title' => 'PHP',
        'cmd'   => 'php -v',
    ],
    /*
    [
        'title' => 'Laravel',
        'cmd'   => 'php artisan --version',
    ],
    [
        'title' => 'laravel folders and permission',
        'funt'  => 'laravel_folders_and_permission',
    ],
    */
    [
        'title' => 'composer install',
        'cmd'   => "composer install --no-plugins --no-scripts",
    ],
    /*
    [
        'title' => 'clear => config, cache, route, view',
        'cmd'   => 'php artisan config:clear ; php artisan route:clear ; php artisan cache:clear ; php artisan view:clear',
    ],
    [
        'title' => 'Migration',
        'cmd'   => "php artisan migrate",
    ],
    */
]);

