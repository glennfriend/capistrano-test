<?php

namespace Cor\JustTest;

class JustTestServiceProvider
{
    public function index()
    {
        echo 'is index';
    }

    public function now()
    {
        echo date('Y-m-d H:i:s');
    }

}