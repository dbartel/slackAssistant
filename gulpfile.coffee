
gulp   =   require "gulp"
env    =   require "gulp-env"
coffee =   require "gulp-coffee"
mocha  =   require "gulp-mocha"

coffeePaths = [
        "index.coffee",
	"src/**/*.coffee"
];

mochaOps = 
        ui: "bdd"
        reporter: "dot"

paths =
       coffee: [ "index.coffee", "src/**/*.coffee" ]
       test:   [ "test/**/*.coffee" ]



gulp.task "build", ->
        return gulp.src paths.coffee
                .pipe coffee(
                        bare: "true"
                        )
                .pipe gulp.dest "dist"

gulp.task "watch", ->
        gulp.watch paths.coffee, ["build"]
        gulp.watch paths.test, ["test"]


gulp.task "travis-ci", ["build", "test"]

gulp.task("default", ["build"])

gulp.task "test", ->
        env({vars: { NODE_ENV: "test" }})
        return gulp.src(paths.test)
                .pipe mocha(mochaOps)

	
