<?php

declare(strict_types=1);

namespace PLT\Psalm\Plugin;

use PLT\Psalm\Plugin\EventHandler\SuppressPropertyHookContracts;
use PLT\Psalm\Plugin\EventHandler\FluentInterfaceAnalysis;
use Psalm\Plugin\PluginEntryPointInterface;
use Psalm\PluginRegistrationSocket;
use SimpleXMLElement;

final class Plugin implements PluginEntryPointInterface
{
    public function __invoke(PluginRegistrationSocket $registration, ?SimpleXMLElement $config = null): void
    {
        require_once __DIR__ . '/EventHandler/FluentInterfaceAnalysis.php';
        require_once __DIR__ . '/EventHandler/SuppressPropertyHookContracts.php';

        $registration->registerHooksFromClass(FluentInterfaceAnalysis::class);
        $registration->registerHooksFromClass(SuppressPropertyHookContracts::class);
    }
}