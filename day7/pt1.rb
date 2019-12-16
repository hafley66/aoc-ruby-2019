require "./IntCode/IntCodeArray.rb"

FindMaxSignal = -> (int_codes, permutation_set) {
  permutation_set.permutation(5).to_a.map { |combos|
    [
      combos,
      combos.reduce(0) do |next_input, amplifier|
        out = ::IntCodeArray::ArrayIORunner.new(
          int_codes.clone,
          inputs: [amplifier, next_input]
        ).call
        out.last
      end
    ]
  }.max_by { |(combo, signal)| signal }
}

class PausableArrayRunner < ::IntCodeArray::ArrayIORunner

  def initialize(*args, **kwargs)
    super(*args, **kwargs)
    @inputs = kwargs[:inputs]
  end

  def call(inputs=[])
    @inputs += inputs
    @int_coder.call(
      &proc do |is_after_op:, op_i:, next_index:, **k|
        puts @inputs.to_s
        puts "is after op? #{is_after_op} #{op_i}"
        if is_after_op
          case op_i
            when ::IntCodeArray::OUTPUT, ::IntCodeArray::TERMINATE
              return self.outputs.last
            end
        end
      end
    )
  end
end


class FindMaxFeedbackSignal
  Amps = [:A, :B, :C, :D, :E]

  def call(int_codes, permutation_set)

    permutation_set.map do |combos|
      amp_machines = combos.map do |phase_setting|
        PausableArrayRunner.new(int_codes, inputs: [phase_setting])
      end

      puts amp_machines.length

      amps_ll = LinkedList.from_array(amp_machines, circular: true)
      queue = [amps_ll.head]

      [
        combos,
        queue.reduce(0, &proc { |signal, amp_node|
          output = amp_node.value.call([signal])
          node = amp_node.next
          while (node.value.int_coder.terminated?) && (node != amp_node)
            node = node.next
          end
          if node != amp_node
            queue.push(node)
          end
          puts "New amp is...#{amp_node}"
          amp_node.value.outputs.last
        })
      ]
    end.max_by { |(combo, signal)| signal }
  end
end

