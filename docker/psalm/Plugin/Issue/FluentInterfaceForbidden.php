<?php

declare(strict_types=1);

namespace PLT\Psalm\Plugin\Issue;

use Psalm\CodeLocation;
use Psalm\Issue\PluginIssue;

final class FluentInterfaceForbidden extends PluginIssue
{
    public function __construct(CodeLocation $codeLocation)
    {
        parent::__construct('Fluent interface is forbidden', $codeLocation);
    }
}