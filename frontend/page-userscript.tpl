{extends file="wrapper.tpl"}
{block name="title"}
    {if $userscript}
        {$userscript->getName()} - {PROJECT_NAME}
    {else}
        Not found
    {/if}
{/block}
{block name="page"}
    <div id="userscriptWrapper">
        {if $userscript}
            <h3>{$userscript->getName()}</h3>
            Author: {$userscript->getAuthor()->getName()}
            <br>
            <br>
            <span class="description">
                {php}
                    $parser = new Parsedown();
                    $purifier = new HTMLPurifier(HTMLPurifier_Config::createDefault());
                    $input = "IyMjaGVsbG8sIG1hcmtkb3duISBoZWxsbyA8YSBuYW1lPSJuIiBocmVmPSJqYXZhc2NyaXB0OmFsZXJ0KCd4c3MnKSI+KnlvdSo8L2E+IDxzY3JpcHQ+YWxlcnQoJ3Rlc3QnKTs8L3NjcmlwdD4gW3NvbWUgdGV4dF0oamF2YXNjcmlwdDphbGVydCgneHNzJykp";
                    $input = base64_decode($input);
                    $output = $parser->text($input);
                    $output = $purifier->purify($output);
                    echo $output;
                {/php}
            </span>
            <textarea spellcheck="false" readonly="readonly">{$userscript->getScript()}</textarea>
        {else}
            A userscript with this id does not exists.
        {/if}
    </div>
{/block}