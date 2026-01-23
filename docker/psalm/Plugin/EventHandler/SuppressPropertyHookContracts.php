<?php

declare(strict_types=1);

namespace PLT\Psalm\Plugin\EventHandler;

use Psalm\Plugin\EventHandler\BeforeAddIssueInterface;
use Psalm\Plugin\EventHandler\Event\BeforeAddIssueEvent;

final class SuppressPropertyHookContracts implements BeforeAddIssueInterface
{
    private const HOOK_PROPERTY_REGEX = '/\bpublic\s+[\w\\?&()|]+\s+\$\w+\s*\{\s*/i';
    private const SUPPRESSABLE_ISSUE_TYPES = ['NoInterfaceProperties'];
    private const HOOK_PROPERTY_ERROR_MESSAGE = 'Interfaces cannot have properties';

    public static function beforeAddIssue(BeforeAddIssueEvent $event): ?bool
    {
        $issue = $event->getIssue();
        $shouldBeSuppressed = in_array($issue::getIssueType(), self::SUPPRESSABLE_ISSUE_TYPES)
            || (
                str_contains($issue->message, self::HOOK_PROPERTY_ERROR_MESSAGE)
                && preg_match(self::HOOK_PROPERTY_REGEX, $issue->code_location->getSelectedText())
            );

        return $shouldBeSuppressed ? false : null;
    }
}