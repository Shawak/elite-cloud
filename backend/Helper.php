<?php

class Helper
{

    public static function GetInput($name, $filter = null, $input = null)
    {
        if (!in_array($input, array(INPUT_GET, INPUT_POST, INPUT_SERVER, INPUT_COOKIE, INPUT_ENV))) {
            die("invalid input variable passed");
        }

        $filters = array(
            "bool" => FILTER_VALIDATE_BOOLEAN,
            "email" => FILTER_VALIDATE_EMAIL,
            "float" => FILTER_VALIDATE_FLOAT,
            "int" => FILTER_VALIDATE_INT,
            "ip" => FILTER_VALIDATE_IP,
            "regexp" => FILTER_VALIDATE_REGEXP,
            "url" => FILTER_VALIDATE_URL,
            "string" => FILTER_SANITIZE_STRING,
            "special" => FILTER_SANITIZE_SPECIAL_CHARS
        );

        if (isset($filter)) {
            if (!array_key_exists($filter, $filters)) {
                die("filter not found");
            }
            $filter = $filters[$filter];
        } else {
            $filter = $filters["string"];
        }

        return filter_input($input, $name, $filter);
    }

    public static function copyyear($year)
    {
        $nowYear = date("Y");
        return '&copy ' . ($nowYear == $year ? $nowYear : $year . ' - ' . $nowYear);
    }

    public static function TryParseDouble($val)
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
            $ret = '';
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
        return $value;
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

    public static function validate_date($dateStr)
    {
        $d = DateTime::createFromFormat('Y-m-d\TH:i', $dateStr);
        return $d && $d->format('Y-m-d\TH:i') === $dateStr;
    }

    public static function validate_date_normal($dateStr)
    {
        $d = DateTime::createFromFormat('Y-m-d', $dateStr);
        return $d && $d->format('Y-m-d') === $dateStr;
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

function session($session, $value = '')
{
    if ($value === '') {
        if (isset($_SESSION[$session])) {
            return $_SESSION[$session];
        }
    } else if ($value !== null) {
        $_SESSION[$session] = $value;
    } else {
        $_SESSION[$session] = null;
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

function cookie($cookie, $value = '', $expire = null)
{
    if ($value === '') {
        $ret = Helper::GetInput($cookie, null, INPUT_COOKIE);
        if (isset($ret)) {
            return $ret;
        }
    } else {
        if ($value === null) {
            $expire = -3600;
        } else if ($expire === null) {
            $expire = 2147483647; // 2^31 - 1 -> January 2038
        }
        setcookie($cookie, $value, time() + $expire);
    }
}

function get($name, $filter = null)
{
    return Helper::GetInput($name, $filter, INPUT_GET);
}

function post($name, $filter = null)
{
    return Helper::GetInput($name, $filter, INPUT_POST);
}

function request($name, $filter = null)
{
    $get = get($name, $filter);
    return !is_null($get) ? $get : post($name, $filter);
}

function dump($exp)
{
    echo '<pre>';
    var_dump($exp);
    echo '</pre>';
}
