<?php

namespace Cor\PrivateInfo\Http\Controllers;

use Request;
use Illuminate\Routing\Controller as Controller;

class HomeController extends Controller
{
    /**
     * Single page application catch-all route.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        /*
        $allowIps = config('private_info.allow.ips');
        echo '<pre>Allow: ';
        echo join(", ", $allowIps);
        echo '</pre>';
        */

        // current ip
        echo Request::ip() . "<br>";
        //
        phpinfo();
    }
}