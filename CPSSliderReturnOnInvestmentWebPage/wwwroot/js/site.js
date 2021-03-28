
function changeScenario() {
    var scenario = document.getElementById("scenarioDropdown").value;
    //console.log(scenario);

    if (scenario === "Ration Change Scenario") {
        document.getElementById("rationChangeScenarioSliderTool").style.display = "block";
        document.getElementById("bolusScenarioSliderTool").style.display = "none";
    }
    else if (scenario === "Bolus Scenario") {
        document.getElementById("bolusScenarioSliderTool").style.display = "block";
        document.getElementById("rationChangeScenarioSliderTool").style.display = "none";
    }

    console.log("here");

    document.getElementById("introduction").scrollIntoView({ behavior: 'smooth' });
}


function calculateCostBenefitRationChangeScenario() {

    var numberOfCowsCalving = document.getElementById("numberOfCowsCalvingSlider").value;
    var costOfAdditivePerkg = document.getElementById("costOfAdditivePerkgSlider").value / 100;
    var additionalAdditiveHeadDay = document.getElementById("additionalAdditiveHeadDaySlider").value;
    var numberOfDaysOnTheRation = document.getElementById("numberOfDaysOnTheRationSlider").value;
    var prevalenceOfSCH = document.getElementById("prevalenceOfSCHSlider").value / 100; //percentage value
    var prevalenceOfMF = document.getElementById("prevalenceOfMFSlider").value / 100; //percentage value
    var numberOfCowsTested = document.getElementById("numberOfCowsTestedSlider").value / 100; //percentage value


    var costPerGram = costOfAdditivePerkg / 1000;
    var additionalAdditiveCostHeadDay = additionalAdditiveHeadDay * costPerGram;

    var costOfCalciulateTest = 5;
    var costOfEachSCHCasePerCowPerYear = 125;
    var costOfEachMFCasePerCowPerYear = 300;

    var costOfSCH = numberOfCowsCalving * prevalenceOfSCH * costOfEachSCHCasePerCowPerYear;
    var costOfMF = numberOfCowsCalving * prevalenceOfMF * costOfEachMFCasePerCowPerYear;
    var totalCost = costOfSCH + costOfMF;

    var numberOfCalciumTestsPerCow = 2;

    var costOfTesting = numberOfCowsCalving * costOfCalciulateTest * numberOfCowsTested * numberOfCalciumTestsPerCow;
    var costOfChangingDryCowAdditive = numberOfCowsCalving * additionalAdditiveCostHeadDay * numberOfDaysOnTheRation * numberOfCowsTested;
    var totalCostOfIntervention = costOfTesting + costOfChangingDryCowAdditive;

    var newPrevalenceOfSCH = 0.3; //percentage value
    var newPrevalenceOfMF = 0.02; //percentage value

    var newCostOfSCH = newPrevalenceOfSCH * numberOfCowsCalving * costOfEachSCHCasePerCowPerYear;
    var newCostOfMF = newPrevalenceOfMF * numberOfCowsCalving * costOfEachMFCasePerCowPerYear;

    var newTotalCost = newCostOfSCH + newCostOfMF;

    var costBenefitOfWholeHerdRationIncrease = ((totalCost - newTotalCost) - totalCostOfIntervention);
    var costBenefitOfWholeHerdRationIncreasePerCow = costBenefitOfWholeHerdRationIncrease / numberOfCowsCalving;

    if (isNaN(costBenefitOfWholeHerdRationIncrease)) {
        costBenefitOfWholeHerdRationIncrease = 0.00;
    }

    if (isNaN(costBenefitOfWholeHerdRationIncreasePerCow)) {
        costBenefitOfWholeHerdRationIncreasePerCow = 0.00;
    }

    document.getElementById("costBenefitOutput").value = costBenefitOfWholeHerdRationIncrease.toFixed(2); //display to 2 decimal places
    document.getElementById("costBenefitOutputPerCow").value = costBenefitOfWholeHerdRationIncreasePerCow.toFixed(2); //display to 2 decimal places
}



function calculateCostBenefitBolusScenario() {

    var numberOfCowsCalving = document.getElementById("numberOfCowsCalvingSlider2").value;
    var numberOfHeifersCalving = document.getElementById("numberOfHeifersCalvingSlider2").value;
    var costOfBolusPerUnit = document.getElementById("costOfBolusPerUnitSlider2").value / 100;
    var numberOfBolusesPerCow = document.getElementById("numberOfBolusesPerCowSlider2").value;
    var numberOfBolusesPerHeifer = document.getElementById("numberOfBolusesPerHeiferSlider2").value;
    var prevalenceOfCowSCH = document.getElementById("prevalenceOfCowSCHSlider2").value / 100; //percentage value
    var prevalenceOfCowMF = document.getElementById("prevalenceOfCowMFSlider2").value / 100; //percentage value
    var prevalenceOfHeiferSCH = document.getElementById("prevalenceOfHeiferSCHSlider2").value / 100; //percentage value
    var prevalenceOfHeiferMF = document.getElementById("prevalenceOfHeiferMFSlider2").value / 100; //percentage value
    
    var costOfTest = 5;

    var costOfBolusPerCow = costOfBolusPerUnit * numberOfBolusesPerCow;
    var costOfBolusPerHeifer = costOfBolusPerUnit * numberOfBolusesPerHeifer;

    var costOfTestingAllCows = numberOfCowsCalving * costOfTest;
    var costOfTestingAllHeifers = numberOfHeifersCalving * costOfTest;

    var blanketTreatmentCostCow = numberOfCowsCalving * costOfBolusPerCow;
    var blanketTreatmentCostHeifer = numberOfHeifersCalving * costOfBolusPerHeifer;

    var numberOfCowsNeedingBolus = (numberOfCowsCalving * prevalenceOfCowSCH) + (numberOfCowsCalving * prevalenceOfCowMF);
    var costOfCowsNeedingBolus = numberOfCowsNeedingBolus * costOfBolusPerCow;

    var numberOfHeifersNeedingBolus = (numberOfHeifersCalving * prevalenceOfHeiferSCH) + (numberOfHeifersCalving * prevalenceOfHeiferMF);
    var costOfHeifersNeedingBolus = numberOfHeifersNeedingBolus * costOfBolusPerHeifer;

    var costBenefitCows = (blanketTreatmentCostCow - (costOfTestingAllCows + costOfCowsNeedingBolus));
    var costBenefitPerCow = (costBenefitCows / numberOfCowsCalving);
    var costBenefitHeifers = (blanketTreatmentCostHeifer - (costOfTestingAllHeifers + costOfHeifersNeedingBolus));
    var costBenefitPerHeifer = (costBenefitHeifers / numberOfHeifersCalving);

    console.log(costBenefitPerCow);

    if (isNaN(costBenefitCows)) {
        costBenefitCows = 0.00;
    }

    if (isNaN(costBenefitPerCow)) {
        costBenefitPerCow = 0.00;
    }

    if (isNaN(costBenefitHeifers)) {
        costBenefitHeifers = 0.00;
    }

    if (isNaN(costBenefitPerHeifer)) {
        costBenefitPerHeifer = 0.00;
    }

    document.getElementById("costBenefitOutputCows2").value = costBenefitCows.toFixed(2);
    document.getElementById("costBenefitOutputPerCow2").value = costBenefitPerCow.toFixed(2);
    document.getElementById("costBenefitOutputHeifers2").value = costBenefitHeifers.toFixed(2);
    document.getElementById("heiferBolusSavingsPerTreatment").value = costBenefitPerHeifer.toFixed(2);

}