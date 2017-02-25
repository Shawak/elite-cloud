<?php

class Helper
{

    public static function copyYear($year)
    {
        $yearNow = date("Y");
        return '© ' . ($yearNow == $year ? $yearNow : $year . ' - ' . $yearNow);
    }

    public static function tryParseDouble($val)
    {
        $val = str_replace(',', '.', $val);
        if (!is_numeric($val)) {
            return false;
        }
        return round(doubleval($val), 2);
    }

    public static function format($value, $clean = false)
    {
        if (is_numeric($value)) { // Number Format
            if ($clean) {
                $ret = self::number_format_clean($value, 2, ',', '.');
            } else {
                $ret = number_format($value, 2, ',', '.');
            }
            return $ret != '' ? $ret : 0;
        } else { // Date Format
            $add = strpos($value, ':') !== false ? ' H:i:s' : '';
            $value = strtotime($value);
            return date('d.m.Y' . $add, $value);
        }
    }

    private static function number_format_clean($number, $precision = 0, $dec_point = '.', $thousands_sep = ',')
    {
        $str = number_format($number, $precision, $dec_point, $thousands_sep);
        $length = strlen($str);
        if ($str[$length - 1] == '0') {
            $str = substr($str, 0, $length - ($str[$length - 2] == '0' ? 3 : 1));
        }
        return $str;
    }
}

/*
  set session:
  session(<name>, <value>);

  get session:
  $value = session(<name>);

  delete session:
  $value = session(<name>, null);
 */

function session($name, $value = '')
{
    if ($value === '') {
        if (isset($_SESSION[$name])) {
            return $_SESSION[$name];
        }
    } else if ($value !== null) {
        $_SESSION[$name] = $value;
    } else {
        $_SESSION[$name] = null;
    }
}

/*
  set cookie:
  cookie(<name>, <value>[, <expire[seconds]>]);
  (Expire Default: Until January 2038)

  get cookie:
  $cookie = cookie(<name>);

  del cookie:
  cookie(<name>, null);
 */

function cookie($name, $value = '', $expire = null)
{
    if ($value === '') {
        if (isset($_COOKIE[$name])) {
            return $_COOKIE[$name];
        }
    } else {
        if ($value === null) {
            $expire = time() + -3600;
        } else if ($expire === null) {
            $expire = 2147483647; // 2^31 - 1 -> January 2038
        }
        setcookie($name, $value, $expire, '/');
    }
}

function get($name, $filter = FILTER_SANITIZE_STRING)
{
    return filter_input(INPUT_GET, $name, $filter);
}

function post($name, $filter = FILTER_SANITIZE_STRING)
{
    return filter_input(INPUT_POST, $name, $filter);
}

function request($name, $filter = FILTER_SANITIZE_STRING)
{
    $get = get($name, $filter);
    return !is_null($get) ? $get : post($name, $filter);
}

function dump($object)
{
    echo '<pre>';
    var_dump($object);
    echo '</pre>';
}
