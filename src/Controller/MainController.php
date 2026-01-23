<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;

class MainController
{
    /*
     * Главная страница
     *
     * @return Response
     */
    public function index(): Response
    {
        return new Response('Hello World');
    }
}
