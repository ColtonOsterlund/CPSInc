#pragma checksum "E:\Programming_Repositories\CPSSliderWebProgram\CPSSliderReturnOnInvestmentWebPage\Pages\Index.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "4dd538d783185444d81d06fd817ba4964f10b745"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(CPSSliderReturnOnInvestmentWebPage.Pages.Pages_Index), @"mvc.1.0.razor-page", @"/Pages/Index.cshtml")]
namespace CPSSliderReturnOnInvestmentWebPage.Pages
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#nullable restore
#line 1 "E:\Programming_Repositories\CPSSliderWebProgram\CPSSliderReturnOnInvestmentWebPage\Pages\_ViewImports.cshtml"
using CPSSliderReturnOnInvestmentWebPage;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"4dd538d783185444d81d06fd817ba4964f10b745", @"/Pages/Index.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"17a7efb1d089bec5e18032e69273fccbbc275860", @"/Pages/_ViewImports.cshtml")]
    public class Pages_Index : global::Microsoft.AspNetCore.Mvc.RazorPages.Page
    {
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_0 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("src", new global::Microsoft.AspNetCore.Html.HtmlString("~/js/site.js"), global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_1 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("value", "", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_2 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("value", "Ration Change Scenario", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_3 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("value", "Bolus Scenario", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        #line hidden
        #pragma warning disable 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext __tagHelperExecutionContext;
        #pragma warning restore 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner __tagHelperRunner = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner();
        #pragma warning disable 0169
        private string __tagHelperStringValueBuffer;
        #pragma warning restore 0169
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __backed__tagHelperScopeManager = null;
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __tagHelperScopeManager
        {
            get
            {
                if (__backed__tagHelperScopeManager == null)
                {
                    __backed__tagHelperScopeManager = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager(StartTagHelperWritingScope, EndTagHelperWritingScope);
                }
                return __backed__tagHelperScopeManager;
            }
        }
        private global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.HeadTagHelper __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_HeadTagHelper;
        private global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper;
        private global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.BodyTagHelper __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_BodyTagHelper;
        private global::Microsoft.AspNetCore.Mvc.TagHelpers.OptionTagHelper __Microsoft_AspNetCore_Mvc_TagHelpers_OptionTagHelper;
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
#nullable restore
#line 3 "E:\Programming_Repositories\CPSSliderWebProgram\CPSSliderReturnOnInvestmentWebPage\Pages\Index.cshtml"
  
    ViewData["Title"] = "Calciulator Tool";

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n<!DOCTYPE html>\r\n<html lang=\"en\">\r\n\r\n");
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("head", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "4dd538d783185444d81d06fd817ba4964f10b7454959", async() => {
                WriteLiteral(@"
    <meta charset=""UTF-8"" />
    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"" />
    <meta http-equiv=""X-UA-Compatible"" content=""ie=edge"" />
    <title>Calciulator</title>
    <link rel=""stylesheet"" href=""fontawesome-5.5/css/all.min.css"" />
    <link rel=""stylesheet"" href=""slick/slick.css"">
    <link rel=""stylesheet"" href=""slick/slick-theme.css"">
    <link rel=""stylesheet"" href=""magnific-popup/magnific-popup.css"">
    <link rel=""stylesheet"" href=""css/bootstrap.min.css"" />
    <link rel=""stylesheet"" href=""css/templatemo-style.css"" />
    ");
                __tagHelperExecutionContext = __tagHelperScopeManager.Begin("script", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "4dd538d783185444d81d06fd817ba4964f10b7455828", async() => {
                }
                );
                __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper>();
                __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_Razor_TagHelpers_UrlResolutionTagHelper);
                __tagHelperExecutionContext.AddHtmlAttribute(__tagHelperAttribute_0);
                await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
                if (!__tagHelperExecutionContext.Output.IsContentModified)
                {
                    await __tagHelperExecutionContext.SetOutputContentAsync();
                }
                Write(__tagHelperExecutionContext.Output);
                __tagHelperExecutionContext = __tagHelperScopeManager.End();
                WriteLiteral("\r\n    <!--\r\n    The Town\r\n    https://templatemo.com/tm-525-the-town\r\n    -->\r\n");
            }
            );
            __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_HeadTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.HeadTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_Razor_TagHelpers_HeadTagHelper);
            await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
            if (!__tagHelperExecutionContext.Output.IsContentModified)
            {
                await __tagHelperExecutionContext.SetOutputContentAsync();
            }
            Write(__tagHelperExecutionContext.Output);
            __tagHelperExecutionContext = __tagHelperScopeManager.End();
            WriteLiteral("\r\n");
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("body", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "4dd538d783185444d81d06fd817ba4964f10b7457716", async() => {
                WriteLiteral("\r\n    <!-- Hero section -->\r\n    <section id=\"hero\" class=\"text-white tm-font-big tm-parallax\">\r\n        <!-- Navigation -->\r\n");
                WriteLiteral(@"
        <div class=""text-center tm-hero-text-container"">
            <div class=""tm-hero-text-container-inner"">
                <h2 class=""tm-hero-title"">Calciulator</h2>
                <p class=""tm-hero-subtitle"">
                    Creative Protein Solutions Inc.
                </p>
            </div>
        </div>

        <div id=""scenarioDropdownDiv"" class=""tm-next tm-intro-next"">

            <label for=""scenarioDropdown"">Select a Scenario:</label>

            <select name=""scenarioDropdown"" id=""scenarioDropdown"" onchange=""changeScenario()"">
                ");
                __tagHelperExecutionContext = __tagHelperScopeManager.Begin("option", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "4dd538d783185444d81d06fd817ba4964f10b7458755", async() => {
                    WriteLiteral("-");
                }
                );
                __Microsoft_AspNetCore_Mvc_TagHelpers_OptionTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.TagHelpers.OptionTagHelper>();
                __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_TagHelpers_OptionTagHelper);
                __Microsoft_AspNetCore_Mvc_TagHelpers_OptionTagHelper.Value = (string)__tagHelperAttribute_1.Value;
                __tagHelperExecutionContext.AddTagHelperAttribute(__tagHelperAttribute_1);
                BeginWriteTagHelperAttribute();
                __tagHelperStringValueBuffer = EndWriteTagHelperAttribute();
                __tagHelperExecutionContext.AddHtmlAttribute("selected", Html.Raw(__tagHelperStringValueBuffer), global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.Minimized);
                BeginWriteTagHelperAttribute();
                __tagHelperStringValueBuffer = EndWriteTagHelperAttribute();
                __tagHelperExecutionContext.AddHtmlAttribute("disabed", Html.Raw(__tagHelperStringValueBuffer), global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.Minimized);
                BeginWriteTagHelperAttribute();
                __tagHelperStringValueBuffer = EndWriteTagHelperAttribute();
                __tagHelperExecutionContext.AddHtmlAttribute("hidden", Html.Raw(__tagHelperStringValueBuffer), global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.Minimized);
                await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
                if (!__tagHelperExecutionContext.Output.IsContentModified)
                {
                    await __tagHelperExecutionContext.SetOutputContentAsync();
                }
                Write(__tagHelperExecutionContext.Output);
                __tagHelperExecutionContext = __tagHelperScopeManager.End();
                WriteLiteral("\r\n                ");
                __tagHelperExecutionContext = __tagHelperScopeManager.Begin("option", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "4dd538d783185444d81d06fd817ba4964f10b74510955", async() => {
                    WriteLiteral("Ration Change");
                }
                );
                __Microsoft_AspNetCore_Mvc_TagHelpers_OptionTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.TagHelpers.OptionTagHelper>();
                __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_TagHelpers_OptionTagHelper);
                __Microsoft_AspNetCore_Mvc_TagHelpers_OptionTagHelper.Value = (string)__tagHelperAttribute_2.Value;
                __tagHelperExecutionContext.AddTagHelperAttribute(__tagHelperAttribute_2);
                await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
                if (!__tagHelperExecutionContext.Output.IsContentModified)
                {
                    await __tagHelperExecutionContext.SetOutputContentAsync();
                }
                Write(__tagHelperExecutionContext.Output);
                __tagHelperExecutionContext = __tagHelperScopeManager.End();
                WriteLiteral("\r\n                ");
                __tagHelperExecutionContext = __tagHelperScopeManager.Begin("option", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "4dd538d783185444d81d06fd817ba4964f10b74512202", async() => {
                    WriteLiteral("Bolus");
                }
                );
                __Microsoft_AspNetCore_Mvc_TagHelpers_OptionTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.TagHelpers.OptionTagHelper>();
                __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_TagHelpers_OptionTagHelper);
                __Microsoft_AspNetCore_Mvc_TagHelpers_OptionTagHelper.Value = (string)__tagHelperAttribute_3.Value;
                __tagHelperExecutionContext.AddTagHelperAttribute(__tagHelperAttribute_3);
                await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
                if (!__tagHelperExecutionContext.Output.IsContentModified)
                {
                    await __tagHelperExecutionContext.SetOutputContentAsync();
                }
                Write(__tagHelperExecutionContext.Output);
                __tagHelperExecutionContext = __tagHelperScopeManager.End();
                WriteLiteral("\r\n            </select>\r\n\r\n        </div>\r\n\r\n");
                WriteLiteral(@"
    </section>

    <section id=""introduction"" class=""tm-section-pad-top"">

        <div class=""text-center"" id=""rationChangeScenarioSliderTool"" style=""display: block;"">
            <br>
            <br>
            <label for=""numberOfCowsCalvingSlider"">Number of cows calving per year: </label>
            <input type=""range"" id=""numberOfCowsCalvingSlider"" value=""0"" min=""0"" max=""500"" step=""10""");
                BeginWriteAttribute("oninput", " oninput=\"", 3576, "\"", 3586, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"0\" min=\"0\" max=\"500\"");
                BeginWriteAttribute("onchange", " onchange=\"", 3636, "\"", 3647, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <br>\r\n            <br>\r\n            <label for=\"costOfAdditivePerkgSlider\">Cost of additive per kg: </label>\r\n            <input type=\"range\" id=\"costOfAdditivePerkgSlider\" value=\"0\" min=\"0\" max=\"1000\" step=\"25\"");
                BeginWriteAttribute("oninput", " oninput=\"", 3874, "\"", 3884, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            $<input value=\"0.00\" min=\"0\" max=\"1000\"");
                BeginWriteAttribute("onchange", " onchange=\"", 3939, "\"", 3950, 0);
                EndWriteAttribute();
                WriteLiteral(@">
            <br>
            <br>
            <label for=""additionalAdditiveHeadDaySlider"">Change in dry cow additive per head per day (g): </label>
            <input type=""range"" id=""additionalAdditiveHeadDaySlider"" value=""0"" min=""0"" max=""1000"" step=""25""");
                BeginWriteAttribute("oninput", " oninput=\"", 4213, "\"", 4223, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"0\" min=\"0\" max=\"1000\"");
                BeginWriteAttribute("onchange", " onchange=\"", 4274, "\"", 4285, 0);
                EndWriteAttribute();
                WriteLiteral(" >\r\n            <br>\r\n            <br>\r\n            <label for=\"numberOfDaysOnTheRationSlider\">Number of days on the ration: </label>\r\n            <input type=\"range\" id=\"numberOfDaysOnTheRationSlider\" value=\"0\" min=\"0\" max=\"182\" step=\"2\"");
                BeginWriteAttribute("oninput", " oninput=\"", 4524, "\"", 4534, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"0\" min=\"0\" max=\"182\"");
                BeginWriteAttribute("onchange", " onchange=\"", 4584, "\"", 4595, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <br>\r\n            <br>\r\n            <label for=\"prevalenceOfSCHSlider\">Prevalence of SCH (%): </label>\r\n            <input type=\"range\" id=\"prevalenceOfSCHSlider\" value=\"50\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("oninput", " oninput=\"", 4802, "\"", 4812, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"50\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("onchange", " onchange=\"", 4863, "\"", 4874, 0);
                EndWriteAttribute();
                WriteLiteral(" >%\r\n            <br>\r\n            <br>\r\n            <label for=\"prevalenceOfMFSlider\">Prevalence of MF (%): </label>\r\n            <input type=\"range\" id=\"prevalenceOfMFSlider\" value=\"2\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("oninput", " oninput=\"", 5079, "\"", 5089, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"2\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("onchange", " onchange=\"", 5139, "\"", 5150, 0);
                EndWriteAttribute();
                WriteLiteral(">%\r\n            <br>\r\n            <br>\r\n            <label for=\"numberOfCowsTestedSlider\">Percentage of cows tested (%): </label>\r\n            <input type=\"range\" id=\"numberOfCowsTestedSlider\" value=\"0\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("oninput", " oninput=\"", 5371, "\"", 5381, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"0\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("onchange", " onchange=\"", 5431, "\"", 5442, 0);
                EndWriteAttribute();
                WriteLiteral(">%\r\n            <br>\r\n            <br>\r\n            <button type=\"button\" id=\"calculateCostBenefitButton\"");
                BeginWriteAttribute("onclick", " onclick=\"", 5548, "\"", 5558, 0);
                EndWriteAttribute();
                WriteLiteral(@">Calculate Cost Benefit</button>
            <br>
            <br>
            <b>Cost Benefit: </b>
            $<output id=""costBenefitOutput"">0.00</output>
            <br>
            <br>
            <b>Cost Benefit Per Cow: </b>
            $<output id=""costBenefitOutputPerCow"">0.00</output>
        </div>





        <div class=""text-center"" id=""bolusScenarioSliderTool"" style=""display: none;"">
            <br>
            <br>
            <label for=""numberOfCowsCalvingSlider2"">Number of cows calving per year: </label>
            <input type=""range"" id=""numberOfCowsCalvingSlider2"" value=""0"" min=""0"" max=""500"" step=""10""");
                BeginWriteAttribute("oninput", " oninput=\"", 6212, "\"", 6222, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"0\" min=\"0\" max=\"500\"");
                BeginWriteAttribute("onchange", " onchange=\"", 6272, "\"", 6283, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <br>\r\n            <br>\r\n            <label for=\"numberOfHeifersCalvingSlider2\">Number of heifers calving per year: </label>\r\n            <input type=\"range\" id=\"numberOfHeifersCalvingSlider2\" value=\"0\" min=\"0\" max=\"300\" step=\"10\"");
                BeginWriteAttribute("oninput", " oninput=\"", 6528, "\"", 6538, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"0\" min=\"0\" max=\"300\"");
                BeginWriteAttribute("onchange", " onchange=\"", 6588, "\"", 6599, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <br>\r\n            <br>\r\n            <label for=\"costOfBolusPerUnitSlider2\">Cost of bolus per unit: </label>\r\n            <input type=\"range\" id=\"costOfBolusPerUnitSlider2\" value=\"1000\" min=\"0\" max=\"1200\" step=\"25\"");
                BeginWriteAttribute("oninput", " oninput=\"", 6828, "\"", 6838, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            $<input value=\"10.00\" min=\"0\" max=\"1200\"");
                BeginWriteAttribute("onchange", " onchange=\"", 6894, "\"", 6905, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <br>\r\n            <br>\r\n            <label for=\"numberOfBolusesPerCowSlider2\">Number of boluses per cow: </label>\r\n            <input type=\"range\" id=\"numberOfBolusesPerCowSlider2\" value=\"0\" min=\"0\" max=\"5\" step=\"1\"");
                BeginWriteAttribute("oninput", " oninput=\"", 7136, "\"", 7146, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"0\" min=\"0\" max=\"5\"");
                BeginWriteAttribute("onchange", " onchange=\"", 7194, "\"", 7205, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <br>\r\n            <br>\r\n            <label for=\"numberOfBolusesPerHeiferSlider2\">Number of boluses per heifer: </label>\r\n            <input type=\"range\" id=\"numberOfBolusesPerHeiferSlider2\" value=\"0\" min=\"0\" max=\"5\" step=\"1\"");
                BeginWriteAttribute("oninput", " oninput=\"", 7445, "\"", 7455, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"0\" min=\"0\" max=\"5\"");
                BeginWriteAttribute("onchange", " onchange=\"", 7503, "\"", 7514, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <br>\r\n            <br>\r\n            <label for=\"prevalenceOfCowSCHSlider2\">Prevalence of cow SCH (%): </label>\r\n            <input type=\"range\" id=\"prevalenceOfCowSCHSlider2\" value=\"50\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("oninput", " oninput=\"", 7733, "\"", 7743, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"50\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("onchange", " onchange=\"", 7794, "\"", 7805, 0);
                EndWriteAttribute();
                WriteLiteral(" >%\r\n            <br>\r\n            <br>\r\n            <label for=\"prevalenceOfCowMFSlider2\">Prevalence of cow MF (%): </label>\r\n            <input type=\"range\" id=\"prevalenceOfCowMFSlider2\" value=\"5\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("oninput", " oninput=\"", 8022, "\"", 8032, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"5\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("onchange", " onchange=\"", 8082, "\"", 8093, 0);
                EndWriteAttribute();
                WriteLiteral(">%\r\n            <br>\r\n            <br>\r\n            <label for=\"prevalenceOfHeiferSCHSlider2\">Prevalence of heifer SCH (%): </label>\r\n            <input type=\"range\" id=\"prevalenceOfHeiferSCHSlider2\" value=\"25\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("oninput", " oninput=\"", 8322, "\"", 8332, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"25\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("onchange", " onchange=\"", 8383, "\"", 8394, 0);
                EndWriteAttribute();
                WriteLiteral(">%\r\n            <br>\r\n            <br>\r\n            <label for=\"prevalenceOfHeiferMFSlider2\">Prevalence of heifer MF (%): </label>\r\n            <input type=\"range\" id=\"prevalenceOfHeiferMFSlider2\" value=\"1\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("oninput", " oninput=\"", 8619, "\"", 8629, 0);
                EndWriteAttribute();
                WriteLiteral(">\r\n            <input value=\"1\" min=\"0\" max=\"100\"");
                BeginWriteAttribute("onchange", " onchange=\"", 8679, "\"", 8690, 0);
                EndWriteAttribute();
                WriteLiteral(">%\r\n            <br>\r\n            <br>\r\n            <button type=\"button\" id=\"calculateCostBenefitButton2\"");
                BeginWriteAttribute("onclick", " onclick=\"", 8797, "\"", 8807, 0);
                EndWriteAttribute();
                WriteLiteral(@">Calculate Cost Benefit</button>
            <br>
            <br>
            <b>Cost Benefit (Cows): </b>
            $<output id=""costBenefitOutputCows2"">0.00</output>
            <br>
            <br>
            <b>Savings per Cow by Testing: </b>
            $<output id=""costBenefitOutputPerCow2"">0.00</output>
            <br>
            <br>
            <b>Cost Benefit (Heifers): </b>
            $<output id=""costBenefitOutputHeifers2"">0.00</output>
            <br>
            <br>
            <b>Savings per Heifer by Testing: </b>
            $<output id=""heiferBolusSavingsPerTreatment"">0.00</output>
        </div>

");
                WriteLiteral("    </section>\r\n\r\n    <!-- Contact -->\r\n");
                WriteLiteral("    <script src=\"js/jquery-1.9.1.min.js\"></script>\r\n    <script src=\"slick/slick.min.js\"></script>\r\n    <script src=\"magnific-popup/jquery.magnific-popup.min.js\"></script>\r\n");
                WriteLiteral("    <script src=\"js/bootstrap.min.js\"></script>\r\n    <script></script>\r\n");
            }
            );
            __Microsoft_AspNetCore_Mvc_Razor_TagHelpers_BodyTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.Razor.TagHelpers.BodyTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_Razor_TagHelpers_BodyTagHelper);
            await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
            if (!__tagHelperExecutionContext.Output.IsContentModified)
            {
                await __tagHelperExecutionContext.SetOutputContentAsync();
            }
            Write(__tagHelperExecutionContext.Output);
            __tagHelperExecutionContext = __tagHelperScopeManager.End();
            WriteLiteral("\r\n</html>");
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<IndexModel> Html { get; private set; }
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary<IndexModel> ViewData => (global::Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary<IndexModel>)PageContext?.ViewData;
        public IndexModel Model => ViewData.Model;
    }
}
#pragma warning restore 1591
