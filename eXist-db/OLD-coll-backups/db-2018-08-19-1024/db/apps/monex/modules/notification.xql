xquery version "3.0";

module namespace notification="http://exist-db.org/apps/monex/notification";

declare namespace jmx="http://exist-db.org/jmx";

import module namespace console="http://exist-db.org/xquery/console" at "java:org.exist.console.xquery.ConsoleModule";
import module namespace mail="http://exist-db.org/xquery/mail" at "java:org.exist.xquery.modules.mail.MailModule";

declare %private function notification:create-email($receiver as xs:string, $subject as xs:string, $data as node()*, $settings as element(),
    $attachment as xs:string?) {
    <mail>
        <from>{$settings/properties/property[@name = "mail.smtp.user"]/@value}</from>
        <to>{$receiver}</to>
        <subject>[monex] {$subject}</subject>
        <message>
            <xhtml>
                <html>
                    <head>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                        <title>[monex] {$subject}</title>
                    </head>
                    <body>
                        <table>
                            <tr>
                                <td>Server Name:</td>
                                <td>{$data/jmx:instance/string()}</td>
                            </tr>
                            <tr>
                                <td>Message:</td>
                                <td>{$data/jmx:status/string()}</td>
                            </tr>
                            <tr>
                                <td>Timestamp:</td>
                                <td>{$data/jmx:timestamp/string()}</td>
                            </tr>
                        </table>
                    </body>
                </html>
            </xhtml>
        </message>
        {
            if (exists($attachment)) then
                <attachment filename="log.xml" mimetype="application/xml">{$attachment}</attachment>
            else
                ()
        }
    </mail>
};

declare function notification:notify($root as xs:string, $instance as element(), $status as xs:string, $response as element(),
    $attachment as element()?) {
    let $notifications := doc($root || "/" || "notifications.xml")//method[@uri = "http://exist-db.org/apps/monex/notification"]
	for $receiver in $notifications/receiver[watching = $instance/@name or not(watching)]
    return
        notification:send-email($receiver/@address, $status, $response, $notifications, $attachment)
};

declare function notification:send-email($receiver as xs:string, $subject as xs:string, $data as node()*, $settings as element(),
    $attachment as element()?) {
    let $session := mail:get-mail-session($settings/properties)
    let $message := notification:create-email($receiver, $subject, $data, $settings, serialize($attachment))
    return
        mail:send-email($session, $message)
};
