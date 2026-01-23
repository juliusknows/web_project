<?php

declare(strict_types=1);

namespace PLT\Psalm\Plugin\EventHandler;

use PhpParser\Node\Stmt;
use PhpParser\Node\Expr;
use PLT\Psalm\Plugin\Issue\FluentInterfaceForbidden;
use Psalm\CodeLocation;
use Psalm\IssueBuffer;
use Psalm\Plugin\EventHandler\AfterStatementAnalysisInterface;
use Psalm\Plugin\EventHandler\Event\AfterStatementAnalysisEvent;

final class FluentInterfaceAnalysis implements AfterStatementAnalysisInterface
{
    public static function afterStatementAnalysis(AfterStatementAnalysisEvent $event): ?bool
    {
        $statement = $event->getStmt();

        if (!$statement instanceof Stmt\Return_) {
            return null;
        }

        $expression = $statement->expr;

        if (!$expression instanceof Expr\Variable) {
            return null;
        }

        if ('this' === $expression->name) {
            $statementSource = $event->getStatementsSource();
            $codeLocation = new CodeLocation($statementSource->getSource(), $statement);
            IssueBuffer::accepts(new FluentInterfaceForbidden($codeLocation), $statementSource->getSuppressedIssues());
        }

        return null;
    }
}