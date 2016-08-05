<?php

class SmartyHandler
{
    static private $instance;

    private function __construct()
    {
    }

    private function __clone()
    {
    }

    private function __wakeup()
    {
    }

    static public function getInstance()
    {
        if (!isset(self::$instance)) {
            $smarty = new Smarty();

            $smarty->setTemplateDir(CFG_DIR_ROOT . '/templates/');
            $smarty->setCompileDir(CFG_DIR_ROOT . '/templates_c/');
            $smarty->setConfigDir(CFG_DIR_ROOT . '/configs/');
            $smarty->setCacheDir(CFG_DIR_ROOT . '/cache/');

            $smarty->caching = Smarty::CACHING_LIFETIME_CURRENT;
            $smarty->debugging = false;

#define( 'CFG_DIR_TEMPLATES', $smarty->getTemplateDir(0) );

            self::$instance = $smarty;
        };
        return self::$instance;
    }

}