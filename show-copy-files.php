#!/usr/bin/env php
<?php

    out('復製檔案前, 請先將你 /path/ 下所有版本管理的檔案都清乾淨');
    out('以方便接下來的修改');
    out('因為你應該會有一些 自定義 的內容被覆蓋, 接下來做搬回去的工作');
    out('your task:');
    out('   1. copy files');
    out('   2. edit .circleci/config.yml about web hook key');
    out('   3. edit you .env & .env.example');
    out('   4. check and edit your *.rb');
    out('');
    out('請輸入你要安裝的路徑: ');
    $path = input();
    $path = ltrim($path, '/ ');
    $path = rtrim($path, '/ ');
    echo "\n";

    echo "mkdir -p /{$path}/.circleci \n";
    echo "mkdir -p /{$path}/tools \n";

    show_copy ('.circleci');
    show_copy ('.editorconfig');
    show_copy ('.ruby-version');
    show_copy ('Capfile');
    show_copy ('Gemfile');
    show_copy ('tools/capistrano');

    exit;

    // --------------------------------------------------------------------------------
    //  function
    // --------------------------------------------------------------------------------

    /**
     * 取得使用者輸入的資料
     */
    function input()
    {
        return trim(fgets(STDIN));
    }

    /**
     * 顯示內容
     */
    function out($content='')
    {
        echo $content . "\n";
    }

    function show_copy($file)
    {
        global $path;

        $info = explode('/', $file);
        if (count($info) <= 1) {
            $copyToFolder = '';
        }
        else {
            array_pop($info);
            $copyToFolder = join('/', $info) . '/';
        }

        printf ("cp -r %-30s %s \n", $file, "/{$path}/{$copyToFolder}");
    }
