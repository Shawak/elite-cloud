<?php

class SmartyHandler
{
    private static $instance;

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
            $smarty->setTemplateDir(DIR_TEMPLATES);
            $smarty->setCompileDir(DIR_SMARTY . 'compiled/');
            $smarty->setConfigDir(DIR_SMARTY . 'config/');
            $smarty->setCacheDir(DIR_SMARTY . 'cache/');
            $smarty->default_modifiers = array('escape:"html"');

            //$smarty->caching = Smarty::CACHING_LIFETIME_CURRENT;
            $smarty->caching = false;
            $smarty->debugging = SMARTY_DEBUGGING;
            self::$instance = $smarty;
        };
        return self::$instance;
    }

}