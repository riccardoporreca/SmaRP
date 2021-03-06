prepare()

context("getTaxAmount")

test_that("Test case Zurich1 (testthat/resources/testZurich1.pdf)",{
  TaxAmount <- getTaxAmount(Income = 200000,
                            rate_group = "C",
                            postalcode = 8002,
                            Age = 40,
                            NChildren = 2,
                            churchtax = "N")

  expect_lt(abs(TaxAmount - 21320) / TaxAmount, 0.05)
  expect_lt(abs(TaxAmount - 21320) / 200000, 0.005)
})

test_that("Test case St.Gallen1 (testthat/resources/testStGallen1.pdf)",{
  TaxAmount <- getTaxAmount(Income = 150000,
                            rate_group = "A",
                            postalcode = 9000,
                            Age = 40,
                            NChildren = 0,
                            churchtax = "N")

  expect_lt(abs(TaxAmount - 30779) / TaxAmount, 0.05)
  expect_lt(abs(TaxAmount - 30779) / 150000, 0.01)
})

test_that("Test case Bern1 (testthat/resources/testStBern1.pdf)",{
  TaxAmount <- getTaxAmount(Income = 124000,
                            rate_group = "C",
                            postalcode = 3010,
                            Age = 32,
                            NChildren = 3,
                            churchtax = "Y")

  expect_lt(abs(TaxAmount - 10308) / TaxAmount, 0.05)
  expect_lt(abs(TaxAmount - 10308) / 124000, 0.005)
})

test_that("Test case Luzern1 (testthat/resources/testLuzern1.pdf)",{
  TaxAmount <- getTaxAmount(Income = 65000,
                            rate_group = "B",
                            postalcode = 6003,
                            Age = 27,
                            NChildren = 0,
                            churchtax = "N")

  expect_lt(abs(TaxAmount - 4476) / TaxAmount, 0.05)
  expect_lt(abs(TaxAmount - 4476) / 65000, 0.005)
})

test_that("Test case Geneve1 (testthat/resources/testGeneve1.pdf)",{
  TaxAmount <- getTaxAmount(Income = 110000,
                            rate_group = "B",
                            postalcode = 1208,
                            Age = 40,
                            NChildren = 2,
                            churchtax = "Y")

  expect_lt(abs(TaxAmount - 4082) / TaxAmount, 0.06)
  expect_lt(abs(TaxAmount - 4082) / 110000, 0.005)
})

test_that("Test case Winterthur1 (testthat/resources/testWinterthur1.pdf)",{
  TaxAmount <- getTaxAmount(Income = 90000,
                            rate_group = "A",
                            postalcode = 8400,
                            Age = 40,
                            NChildren = 0,
                            churchtax = "N")
  
  expect_lt(abs(TaxAmount -  9767) / TaxAmount, 0.05)
  expect_lt(abs(TaxAmount -  9767) / 90000, 0.005)
})



