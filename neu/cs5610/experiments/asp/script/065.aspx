﻿<%@ Page Language="C#" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Experiment</title>
    <link rel="stylesheet" type="text/css" href="~/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="~/css/wam.css" />
    <script src="../../../javascript/jquery-min.js"></script>
    <script src="../../../javascript/jquery-ui.min.js"></script>
    <script src="../../../javascript/wam.js"></script>
    <style>
        ul.wam-script {
            padding : 0px;
        }
        ul.wam-script input[type=text] {
            width: 75%;
            height: 30px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="container">


        <div class="row">
            <div class="col-sm-4">
    
            <h1>Run Script</h1>
           <ul class="wam-no-bullets wam-script">
        <% int counter = 0;
           ArrayList gotoFrom = new ArrayList();
           ArrayList gotoTo   = new ArrayList();
           string delete = Request.Params["delete"];
           foreach(object param in Request.Params) {
               if (param.ToString().StartsWith("wam")) {
                   string value = Request.Params[param.ToString()];
                   if (value == "" || value.Length == 0)
                   {
                       continue;
                   }
                   if ((counter + "") != delete) {
        %>         <li>
                        <div class="wam-cb wam-top" id="<%= counter %>">
                            <div class="wam-left"><span class="wam-arrow">&#9658;</span></div>
                            <div class="wam-bottom"><span class="wam-arrow">&#9650</span></div>
                            <div class="wam-top"><span class="wam-arrow">&#9660;</span></div>
                            <div class="wam-right"><span class="wam-arrow">&#9668;</span></div>
                            <div class="wam-content">
                                <%= counter %> <input class="wam-width-200 wam-shadow-border wam-no-borders" type="text" name="wam-<%= counter %>" value="<%= value %>"/>
                                <button name="update" value="<%= counter %>" class="btn btn-primary btn-sm pull-right">&#10004;</button>
                                <button name="delete" value="<%= counter %>" class="btn btn-danger btn-sm pull-right">&times;</button>
                            </div>
                        </div>

                        <div class="wam-line-vertical-middle wam-height-50"></div>
                    </li>
        <%          if (value.Contains("goto"))
                    {
                        int gotoIndex = value.IndexOf("goto");
                        int parenOpenIndex = value.IndexOf("(", gotoIndex);
                        int parenCloseIndex = value.IndexOf(")", gotoIndex);
                        string gotoParam = value.Substring(parenOpenIndex+1, parenCloseIndex - parenOpenIndex - 1);
                        gotoFrom.Add(counter + "");
                        gotoTo.Add(gotoParam);
                    }
                    counter++;
                   }
                   else
                   {
                       delete = "";
                   }
                   
               }
           }
        %>     <li>
                        <div class="wam-cb wam-top" id="-1">
                            <div class="wam-left"><span class="wam-arrow">&#9658;</span></div>
                            <div class="wam-bottom"><span class="wam-arrow">&#9650</span></div>
                            <div class="wam-top"><span class="wam-arrow">&#9660;</span></div>
                            <div class="wam-right"><span class="wam-arrow">&#9668;</span></div>
                            <div class="wam-content">
                                <input placeholder="Type Here" type="text" id="0" name="wam-new-line" autofocus="autofocus" class="wam-width-200 wam-no-borders wam-shadow-border" /><button class="btn btn-success btn-sm pull-right">&#10004;</button>
                            </div>
                        </div>
                </li>
           </ul>
                <button type="submit" class="btn btn-success pull-right" name="wam-run">Run</button>
            </div>

            <div class="col-sm-8">
                
                <h1>Documentation</h1>

                <h2>HTML</h2>
                <p> In this experiment we write the script to the page
                    and execute it when we click on a Run button.
                    To accomplish this, we add a new button labeled
                    <b class="wam-highlight">Run</b> with the name <b class="wam-highlight">wam-run</b>.
                </p>
                <pre>
&lt;button type=&quot;submit&quot; class=&quot;btn btn-success pull-right&quot; name=&quot;wam-run&quot;&gt;Run&lt;/button&gt;</pre>

                <h2>ASP</h2>
                <p> If the Run button is clicked, it will submit the form
                    and add the wam-run query parameter to the query string.
                    We can check for this in ASP and write out the stements
                    inside a script tag. When the browser receives the
                    rendered page, it will execute the script.
                </p>
                <pre>
&lt;script&gt;
&lt;%
counter = 0;
foreach(object param in Request.Params) {
    if (param.ToString().StartsWith(&quot;wam&quot;)) {
        string value = Request.Params[param.ToString()];
        if (value == &quot;&quot; || value.Length == 0)
            continue;
        if ((counter + &quot;&quot;) != delete) {%&gt;
        &lt;%= value %&gt;
&lt;%          counter++;
        }
        else
        {
            delete = &quot;&quot;;
        }
    }
}
%&gt;&lt;/script&gt;</pre>

            </div>

        </div>

        <br />

        <rasala:FileView ID="fileView" runat="server" />

<script>
<%
if (Request.Params["wam-run"] != null)
{
    counter = 0;
    foreach(object param in Request.Params) {
        if (param.ToString().StartsWith("wam")) {
            string value = Request.Params[param.ToString()];
            if (value == "" || value.Length == 0)
                continue;
            if ((counter + "") != delete) {%>
            <%= value %>
    <%          counter++;
            }
            else
            {
                delete = "";
            }
        }
    }
}
%></script>

    <script>
        $(function () {
            <%
        for (int i = 0; i < gotoFrom.Count; i++ )
        {
            string from = gotoFrom[i].ToString();
            string to = gotoTo[i].ToString();
        %>
            gotoRenderer(<%= from %>, <%= to %>);
        <%
        }
        %>
        });
    </script>

        </div>
    </form>
</body>
</html>
