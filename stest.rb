	 def statistical_tests_decision_tree(vector1, vector2)
	  # Determine if vectors are quantitative or qualitative
	  vector1_type = vector_type(vector1)
	  vector2_type = vector_type(vector2)

	  # Determine if vectors have less than 5 unique values
	  vector1_unique_count = vector1.uniq.count
	  vector2_unique_count = vector2.uniq.count

	  # Decision tree logic
	  if vector1_type == :qualitative || vector2_type == :qualitative
	    # At least one vector is qualitative
	    if vector1_unique_count < 5 || vector2_unique_count < 5
	      # At least one vector has less than 5 unique values
	      puts "Use non-parametric tests (e.g., Wilcoxon rank sum test)"
	      puts "R function to validate assumptions: wilcox.test()"
	      puts "R function for hypothesis test: wilcox.test()"
	    else
	      # Both vectors have 5 or more unique values
	      puts "Use parametric tests (e.g., t-test)"
	      puts "R function to validate assumptions: t.test()"
	      puts "R function for hypothesis test: t.test()"
	    end
	  else
	    # Both vectors are quantitative
	    if vector1_unique_count < 5 || vector2_unique_count < 5
	      # At least one vector has less than 5 unique values
	      puts "Use non-parametric tests (e.g., Mann-Whitney U test)"
	      puts "R function to validate assumptions: wilcox.test()"
	      puts "R function for hypothesis test: wilcox.test()"
	    else
	      # Both vectors have 5 or more unique values
	      # Check if regression analysis is appropriate
	      if vector1.size > 10 && vector2.size > 10
	        # Check if logistic regression is appropriate
	        if binary_or_multiple_categorical(vector1, vector2)
	          puts "Use logistic regression (binary or multiple)"
	          puts "R function to validate assumptions: glm()"
	          puts "R function for logistic regression: glm()"
	        elsif multinomial_categorical(vector1, vector2)
	          puts "Use multinomial logistic regression"
	          puts "R function to validate assumptions: multinom()"
	          puts "R function for multinomial logistic regression: multinom()"
	        elsif ordinal_categorical(vector1, vector2)
	          puts "Use ordinal logistic regression"
	          puts "R function to validate assumptions: polr()"
	          puts "R function for ordinal logistic regression: polr()"
	        else
	          puts "Use parametric tests (e.g., paired t-test)"
	          puts "R function to validate assumptions: t.test()"
	          puts "R function for hypothesis test: t.test()"
	        end
	      else
	        puts "Use parametric tests (e.g., paired t-test)"
	        puts "R function to validate assumptions: t.test()"
	        puts "R function for hypothesis test: t.test()"
	      end
	    end
	  end
	end

	def vector_type(vector)
	  # Check if vector is qualitative or quantitative
	  unique_count = vector.uniq.count
	  if unique_count < 5
	    :qualitative
	  else
	    :quantitative
	  end
	end

	def binary_or_multiple_categorical(vector1, vector2)
	  # Check if the dependent variable is binary or multiple categorical
	  unique_values = (vector1 + vector2).uniq
	  unique_values.size <= 2 || unique_values.all? { |value| value.is_a?(String) }
	end

	def multinomial_categorical(vector1, vector2)
	  # Check if the dependent variable is multinomial categorical
	  unique_values = (vector1 + vector2).uniq
	  unique_values.size > 2 && unique_values.all? { |value| value.is_a?(String) }
	end

	def ordinal_categorical(vector1, vector2)
	  # Check if the dependent variable is ordinal categorical
	  unique_values = (vector1 + vector2).uniq
	  unique_values.all? { |value| value.is_a?(Integer) }
	end


