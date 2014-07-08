angular.module "punchCard", []

angular.module("punchCard").directive "punchCard", ($timeout) ->
    restrict: "AE"

    scope:
        data: "="
        plural: "@"
        singular: "@"

    link: ($scope, $element, $attrs) ->
        $scope.days = [
            "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
        ]
        $scope.hours = [
            "00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11",
            "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"
        ]

        flatten = [].concat.apply([], $scope.data)
        max = flatten.sort((a, b) -> a - b)[flatten.length - 1]
        $scope.size = (n) -> Math.floor(100 / max * +n / 10)

        $scope.description = (n) ->
            if n == 1
                $scope.singular || "event"
            else
                $scope.plural || "events"

        $scope.makeVisible = (n) ->
            $timeout (-> $scope.isVisible = true), 20

        $scope.isVisible = $attrs.animate == undefined

    template: """
        <div id="punch-card" ng-class="{visible: isVisible}">
            <div class="punch-card-day" ng-init="makeVisible()" ng-repeat='day in days'>
                <div class="punch-card-day-name">
                    <div class="punch-card-day-name-label">{{ day }}</div>
                </div>
                <div class="punch-card-hour"
                     ng-repeat='hour in hours'
                     ng-init="n = data[$parent.$index][$index]">
                    <div class="punch-card-hour-data size-{{ size(n) }}"></div>
                    <div class="punch-card-hour-tooltip" ng-show="n">
                        <b>{{ n }}</b> {{ description(n) }}
                        <div class="arrow"></div>
                    </div>
                    <div class="punch-card-hour-tick"></div>
                </div>
            </div>
            <div class="punch-card-hour-name">
                <div class="punch-card-hour-name-label" ng-repeat='hour in hours'>
                    {{ hour }}
                </div>
            </div>
        </div>
    """