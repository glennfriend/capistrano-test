<?php

namespace Cor\PrivateInfo\Http\Middleware;

use Exception;
use Closure;
use Request;

class IpCheckMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @param  string|null  $guard
     * @return mixed
     */
    public function handle($request, Closure $next, $guard = null)
    {
        // check by auth
        // $this->middleware(Authenticate::class);

        // check by ip
        $userIp = Request::ip();
        $isAllowIp = $this->checkIp($userIp);
        if (! $isAllowIp) {
            // throw new Exception('Permission Deny');
            echo "Permission Deny" . "\n";
            exit;
            // return redirect('/home');
        }

        if ($userIp !== $_SERVER['REMOTE_ADDR']) {
            echo '52f62435gh9486gh4985gf645g6';
            exit;
        }

        return $next($request);
    }

    // --------------------------------------------------------------------------------
    //  private
    // --------------------------------------------------------------------------------

    protected function checkIp(string $userIp)
    {
        $allowIps = (array) config('private_info.allow.ips');

        if (! $allowIps) {
            return false;
        }

        if (in_array($userIp, $allowIps)) {
            return true;
        }
        else {
            return false;
        }

    }

}
